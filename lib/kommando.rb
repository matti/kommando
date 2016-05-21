require "pty"
require "timeout"

require_relative "kommando/error"
require_relative "kommando/version"
require_relative "kommando/buffer"

class Kommando

  # http://stackoverflow.com/a/7263243
  module SafePTY
    def self.spawn command, *args, &block

      PTY.spawn(command, *args) do |r,w,p|
        begin
          yield r,w,p
        rescue Errno::EIO
        ensure
          Process.wait p
        end
      end

      $?.exitstatus
    end
  end

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
    @thread_did_timeout = nil

    @code = nil
    @executed = false

    @retry = opts[:retry] == true
  end

  def run
    return false if @executed
    @executed = true

    command, *args = @cmd.split " "
    begin
      exitstatus = SafePTY.spawn(command, *args) do |stdout, stdin, pid|
        if @retry && stdout.eof?
          @executed = false
          return run
        end

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

        if @timeout
          begin
            Timeout.timeout(@timeout) do
              thread_stdout.join
            end
          rescue Timeout::Error
            Process.kill('KILL', pid)
            @thread_did_timeout = true
          end
        else
          thread_stdout.join
        end

        stdout_file.close if @output_file
      end

      @code = if @thread_did_timeout
        1
      else
        exitstatus
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
