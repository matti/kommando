require "pty"

require_relative "kommando/error"
require_relative "kommando/version"
require_relative "kommando/buffer"

class Kommando

  def initialize(cmd)
    @cmd = cmd
    @stdout = Buffer.new
  end

  def run
    command, *args = @cmd.split " "
    begin
      PTY.spawn(command, *args) do |stdout, stdin, pid|
        Thread.abort_on_exception = true

        thread_stdout = Thread.new do
          while true do
            break if stdout.eof?

            c = stdout.getc
            @stdout.append c if c
          end
        end
        thread_stdout.join

        # http://stackoverflow.com/a/7263243
        Process.wait(pid)

        @code = $?.exitstatus
      end
    rescue => ex
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
