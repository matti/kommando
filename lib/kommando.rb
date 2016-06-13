require "pty"
require "timeout"

require_relative "kommando/error"
require_relative "kommando/version"
require_relative "kommando/buffer"

class Kommando

  def initialize(cmd, opts={})
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
    end
    @timeout_happened = false
    @kill_happened = false

    @env = opts[:env] || {}

    @code = nil
    @executed = false

    @retry = opts[:retry] == true

    @thread = nil
    @pid = nil

    @shell = false

    @matchers = {}
    @matcher_buffer = ""

    @latency = opts[:latency]
  end

  def run_async
    @thread = Thread.new do
      run
    end
  end

  def kill
    Process.kill('KILL', @pid)
    @kill_happened = true

    sleep 0.001 until @code # let finalize
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
      PTY.spawn(command, *interpolated_args) do |stdout, stdin, pid|
        if @retry && stdout.eof?
          @executed = false
          return run
        end

        @pid = pid

        if @output_file
          stdout_file = File.open @output_file, 'w'
          stdout_file.sync = true
        end

        Thread.abort_on_exception = true
        thread_stdout = Thread.new do
          while true do
            begin
              break if stdout.eof?
            rescue Errno::EIO
              # Linux http://stackoverflow.com/a/7263243
              break
            end

            c = nil
            begin
              Timeout.timeout(0.1) do
                c = stdout.getc
              end
            rescue Timeout::Error
              # sometimes it just hangs.
            end

            @stdout.append c if c
            print c if @output_stdout

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

        thread_stdin = Thread.new do
          sleep 0.1 # allow program to start, do not write "in terminal"
          while true do
            c = @stdin.getc
            unless c
              sleep 0.01
              next
            end
            sleep @latency if @latency
            stdin.write c
          end
        end

        if @timeout
          begin
            Timeout.timeout(@timeout) do
              thread_stdout.join
            end
          rescue Timeout::Error
            Process.kill('KILL', pid)
            @timeout_happened = true
          end
        else
          thread_stdout.join
        end

        stdout_file.close if @output_file
      end

      @code = if @timeout_happened
        1
      elsif @kill_happened
        137
      else
        unless $?
          begin
            Timeout.timeout(0.1) do
              Process.wait #WIP: trying to fix weird linux stuff when $? is nil
            end
          rescue Timeout::Error
          end
        end

        $?.exitstatus
      end
    rescue RuntimeError => ex
      if ex.message == "can't get Master/Slave device"
        #suppress, weird stuff.
      end
    rescue Errno::ENOENT => ex
      raise Kommando::Error, "Command '#{command}' not found"
    end

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
end
