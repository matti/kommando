require 'spec_helper'
require 'tempfile'

describe Kommando do
  describe 'opts' do
    describe 'timeout' do
      it 'aborts execution with seconds' do

        k = Kommando.new "sleep 10000", {
          timeout: 1
        }
        k.instance_variable_set "@timeout", 0.0001

        k.run

        expect(k.code).to be(1)
      end

      it 'aborts execution with fractional seconds' do
        k = Kommando.new "sleep 1", {
          timeout: 0.0001
        }
        k.run
        expect(k.code).to be(1)
      end
    end

    describe 'output' do
      it 'outputs to standard out' do
        k = Kommando.new "uptime", {
          output: true
        }
        expect { k.run }.to output(/\d+ users, load averages:/).to_stdout
      end

      it 'outputs to file' do
        outfile = Tempfile.new

        k = Kommando.new "uptime", {
          output: outfile.path
        }
        expect { k.run }.not_to output(/\d+ users, load averages:/).to_stdout

        sleep 0.01 until k.code == 0  #TODO: k.wait

        contents = File.read outfile.path
        expect(contents).to match /\d+ users, load averages:/
      end

      it 'flushes in sync' do
        outfile = Tempfile.new
        k = Kommando.new "$ echo hello; sleep 1", {
          output: outfile.path
        }

        k.run_async
        sleep 0.05

        expect(k.out).to eq "hello"
      end
    end
  end
end
