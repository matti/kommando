require "pty"
require "timeout"

require_relative "kommando/error"
require_relative "kommando/version"
require_relative "kommando/buffer"

class Kommando

  def initialize(cmd, opts={})
    @cmd = cmd
    @stdout = Buffer.new

    @output_stdout = opts[:output] == true
    @output_file = if opts[:output].class == String
      opts[:output]
    end

    @timeout = if opts[:timeout].class == Float
      opts[:timeout]
    elsif opts[:timeout].class == Fixnum
      opts[:timeout].to_f
    end

    @code = nil
    @executed = false
  end

  def run
    return false if @executed
    @executed = true

    command, *args = @cmd.split " "
    begin
      PTY.spawn(command, *args) do |stdout, stdin, pid|
        # if stdout.eof?
        #   @executed = false
        #   return run
        # end

        if @output_file
          stdout_file = File.open @output_file, 'w'
          stdout_file.sync = true
        end

        Thread.abort_on_exception = true
        thread_stdout = Thread.new do
          while true do
            break if stdout.eof?

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
            stdout_file.write c if @output_file
          end
        end

        thread_did_timeout = nil
        if @timeout
          begin
            Timeout.timeout(@timeout) do
              thread_stdout.join
            end
          rescue Timeout::Error
            Process.kill('KILL', pid)
            thread_did_timeout = true
          end
        else
          thread_stdout.join
        end

        stdout_file.close if @output_file

        # http://stackoverflow.com/a/7263243
        Process.wait(pid)

        @code = if thread_did_timeout
          1
        else
          $?.exitstatus
        end

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
    @stdout.to_s
  end

  def code
    @code
  end
end
