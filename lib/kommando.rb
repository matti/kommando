require "pty"

require_relative "kommando/version"
require_relative "kommando/buffer"

class Kommando

  def initialize(cmd)
    @cmd = cmd
    @stdout = Buffer.new
  end

  def run
    PTY.spawn(@cmd, "") do |stdout, stdin, pid|
      Thread.abort_on_exception = true

      thread_stdout = Thread.new do
        while true do
          break if stdout.eof?

          c = stdout.getc
          @stdout.append c if c
        end
      end

      thread_stdout.join
    end

    true
  end

  def out
    @stdout.to_s
  end
end
