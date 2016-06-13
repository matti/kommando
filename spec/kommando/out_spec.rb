require 'spec_helper'
require 'tempfile'

describe Kommando do
  describe 'out' do
    it 'is empty if not run' do
      expect(Kommando.new("").out).to eq ""
    end

    it 'has the stdout' do
      uptime = Kommando.new "uptime"
      uptime.run
      uptime

      expect(uptime.out).to match /\d+ users, load averages:/
    end

    describe 'on' do
      it "sets matcher" do
        tmpfile = Tempfile.new
        k = Kommando.new "nano #{tmpfile.path}", {
          output: true
        }
        k.in << "hello\r"
        k.in << "\x1B\x1Bx"

        k.out.on "Save modified buffer" do
          puts "LOL"
        end
      end
    end
  end
end
