require "pty"
require "timeout"

require_relative "kommando/error"
require_relative "kommando/version"
require_relative "kommando/buffer"
require_relative "kommando/when"

class Kommando
  class << self
    @@timeout = nil
    @@whens = nil

    def run(cmd, opts={})
      k = Kommando.new cmd, opts
      k.run
      k
    end

    def run_async(cmd, opts={})
      k = Kommando.new cmd, opts
      k.run_async
      k
    end

    def puts(cmd, opts={})
      k = Kommando.new cmd, opts
      k.run
      Kernel.puts k.out
      k
    end

    def timeout
      @@timeout
    end

    def timeout=(value)
      @@timeout=value
    end


    def when(event_name, &block)
      @@whens ||= Kommando::When.new
      @@whens.register event_name, block
    end

    def when=(w)
      @@whens = w
    end
  end

  def initialize(cmd, opts={})
    Thread.abort_on_exception=true

    @cmd = cmd
    @stdout = Buffer.new
    @stdin = Buffer.new

    @output_stdout = opts[:output] == true
    @output_file = if opts[:output].class == String
      opts[:output]
    end

    @timeout = if opts[:timeout].class == Float
      opts[:timeout]
    elsif opts[:timeout].class == Fixnum
      opts[:timeout].to_f
    else
      @timeout = @@timeout
    end

    @timeout_happened = false
    @kill_happened = false
    @rescue_happened = false

    @env = opts[:env] || {}

    @code = nil
    @executed = false
    @process_completed = false

    if opts[:retry]
      if opts[:retry][:times]
        @retry_times_total = opts[:retry][:times]
        @retry_time = @retry_times_total
      end
      if opts[:retry][:sleep]
        @retry_sleep = opts[:retry][:sleep]
      end
    end

    @start_fired = false

    @thread = nil
    @pid = nil

    @shell = false

    @matchers = {}
    @matcher_buffer = ""

    @whens = {}
    @when = When.new

    if @@whens
      @@whens.instance_variable_get("@whens").each_pair do |event_name, blocks|
        blocks.each do |block|
          @when.register event_name, block
        end
      end
    end
  end

  def run_async
    @thread = Thread.new do
      run
    end
  end

  def kill
    begin
      Process.kill('KILL', @pid)
    rescue Errno::ESRCH => ex
      #raise ex # see if happens
    end

    @kill_happened = true
    begin
      Timeout.timeout(1) do
        sleep 0.001 until @code # let finalize
      end
    rescue Timeout::Error => ex
      raise ex # let's see if happens
    end
  end

  def run
    return false if @executed
    @executed = true

    command, *args = if @cmd.start_with? "$"
      @shell = true
      trash, line = @cmd.split "$", 2
      line.lstrip!
      ["bash", "-c", line]
    else
      @cmd.split " "
    end

    @env.each_pair do |k,v|
      ENV[k.to_s] = v
    end

    interpolated_args = []
    if @shell
      interpolated_args << args.shift
      shell_line = args[0]

      to_be_interpolated = shell_line.scan(/\$[^\s]*/)
      to_be_interpolated.each do |to_interpolate|
        if ENV[to_interpolate]
          shell_line.gsub!("${to_interpolate}", ENV[to_interpolate])
        else
          shell_line.gsub!("${to_interpolate}", "")
        end
      end

      interpolated_args << shell_line
    else
      args.each do |arg|
        interpolated_args << if arg.start_with? "$"
          env_name = arg.split("$")[1]
          ENV[env_name]
        else
          arg
        end
      end
    end

    begin
      debug "pty before spawn"
      make_pty_testable.spawn(command, *interpolated_args) do |stdout, stdin, pid|
        debug "pty in spawn"

        @pid = pid

        if @output_file
          stdout_file = File.open @output_file, 'w'
          stdout_file.sync = true
        end

        thread_stdin = nil
        self.when :start do
          thread_stdin = Thread.new do
            while true do
              break if @process_completed
              # c = nil
              # Timeout.timeout(1) do
              c = @stdin.getc
              #end

              unless c
                sleep 0.01
                next
              end

              stdin.write c
            end
          end
        end


        debug "thread_stdin started"

        unless @start_fired
          debug "when :start firing"
          @when.fire :start
          debug "when :start fired"
        else
          debug "when :start NOT fired, as :start has already been fired"
        end

        if @timeout
          begin
            Timeout.timeout(@timeout) do
              process_stdout(pid, stdout, stdout_file)
            end
          rescue Timeout::Error
            Process.kill('KILL', pid)
            @timeout_happened = true
          end
        else
          process_stdout(pid, stdout, stdout_file)
        end
        @process_completed = true
        debug "thread_stdin joining"
        thread_stdin.join
        debug "thread_stdin joined"
        stdout_file.close if @output_file
      end

    rescue RuntimeError => ex
      if ex.message == "can't get Master/Slave device"
        #suppress, weird stuff.
        @rescue_happened = true
      else
        raise ex
      end
    rescue ThreadError => ex
      if ex.message == "can't create Thread: Resource temporarily unavailable"
        if @retry_time && @retry_time > 0
          @executed = false
          @retry_time -= 1
          sleep @retry_sleep if @retry_sleep
          @when.fire :retry
          return run
        end

        raise_after_callbacks(ex)
      else
        raise_after_callbacks(ex)
      end
    rescue Errno::ENOENT => ex
      @when.fire :error
      raise Kommando::Error, "Command '#{command}' not found"
    ensure
      @code = if @timeout_happened
        1
      elsif @kill_happened
        137
      else
        begin
          Timeout.timeout(0.1) do
            Process.wait @pid if @pid
          end
        rescue Errno::ECHILD => ex
          # safe to supress, I guess
        rescue Timeout::Error => ex
          # seems to be okay...
        end

        $?.exitstatus
      end

      @when.fire :error if @rescue_happened
    end

    @when.fire :timeout if @timeout_happened
    @when.fire :exit

    debug "run returning true"
    true
  end

  def out
    string = if @shell
      @stdout.to_s.strip
    else
      @stdout.to_s
    end

    kommando = self
    string.define_singleton_method(:on) do |matcher, &block|
      matchers = kommando.instance_variable_get(:@matchers)
      matchers[matcher] = block
    end

    string
  end

  def code
    @code
  end

  def in
    @stdin
  end

  def wait
    debug "k.wait starting"
    exited = false
    self.when :exit do
      exited = true
    end
    sleep 0.0001 until exited
    debug "k.wait done"
  end

  def when(event, &block)
    @when.register event, block
  end

  private

  def debug(msg)
    return unless ENV["DEBUG"]
    print "|#{msg}"
  end

  def raise_after_callbacks(exception)
    @when.fire :error
    @when.fire :exit
    raise exception
  end

  def make_pty_testable
    PTY
  end

  def process_stdout(pid, stdout, stdout_file)
    flushing = false
    while true do
      debug "process_stdout started"
      begin
        Process.getpgid(pid)
      rescue Errno::ESRCH => ex
        flushing = true
      end

      c = nil
      begin
        c = stdout.getc
      rescue Errno::EIO
        # Linux http://stackoverflow.com/a/7263243
        # TODO: only try-catch on linux?
        break
      end

      break if flushing == true && c == nil
      next unless c

      @stdout.append c if c
      print c if @output_stdout
      stdout_file.write c if @output_file

      if c
        @matcher_buffer << c

        matchers_copy = @matchers.clone # blocks can insert to @matchers while iteration is undergoing
        matchers_copy.each_pair do |matcher,block|
          if @matcher_buffer.match matcher
            block.call
            @matchers.delete matcher # do not match again  TODO: is this safe?
          end
        end
      end
    end
  end

end
