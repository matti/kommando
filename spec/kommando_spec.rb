require 'spec_helper'

require 'tempfile'

describe Kommando do
  it 'has a version number' do
    expect(Kommando::VERSION).not_to be nil
  end

  describe 'initialization' do
    it 'requires cmd as an argument' do
      k = Kommando.new "uptime"
      expect(k).to be_an_instance_of(Kommando)
    end

    it 'accepts additional options as the second argument' do
      k = Kommando.new "uptime", {
        output: true
      }
      expect(k).to be_an_instance_of(Kommando)
    end
  end

  describe 'running async' do
    it 'starts in background' do
      k = Kommando.new "sleep 10"

      time_before = Time.now.to_i
      k.run_async
      expect(Time.now.to_i).to eq time_before
    end
  end

  describe 'killing' do
    it 'kills the current run' do
      k = Kommando.new "sleep 10"
      Thread.new do
        sleep 0.05
        k.kill
      end
      time_before = Time.now.to_i
      k.run

      expect(Time.now.to_i).to eq time_before
      expect(k.code).to be nil
    end
  end

  describe 'running' do
    let(:uptime_kommand) { Kommando.new "uptime" }
    let(:completed_uptime_kommand) do
      uptime = Kommando.new "uptime"
      uptime.run
      uptime
    end

    it 'runs the cmd' do
      expect(uptime_kommand.run).to be true
    end

    it 'can not run multiple times' do
      once = Kommando.new "uptime"
      expect(once.run).to be true
      expect(once.run).not_to be true
    end

    it 'should raise nice error message when a command is not found' do
      notfound = Kommando.new("thiscommandcanpossiblynotbefoundonthissystemevenin1999 --i-am-pretty-sure")
      expect{notfound.run}.to raise_error(Kommando::Error, "Command 'thiscommandcanpossiblynotbefoundonthissystemevenin1999' not found")
    end

    describe 'args' do
      let(:head_kommand) { Kommando.new "head .rspec" }

      it 'runs a cmd with arguments' do
        expect(head_kommand.run).to be true
      end

      it 'calls passes args correctly' do
        k = Kommando.new "head .rspec"
        expect(k.run).to eq true
        expect(k.code).to eq 0
        sleep 0.5 # TODO: bin/stress 10 100 makes this fail
        expect(k.out).to eq "--format documentation\r\n--color\r\n"
      end
    end

    describe 'code' do
      it 'has nil code if not run' do
        notrun = Kommando.new "exit"
        expect(notrun.code).to be nil
      end

      it 'has success code on clean exit' do
        success = Kommando.new "/usr/bin/true"
        success.run
        expect(success.code).to eq 0
      end

      it 'has error code on not clean exit' do
        failure = Kommando.new "/usr/bin/false"
        failure.run
        expect(failure.code).to eq 1
      end
    end

    describe 'out' do
      it 'is empty if not run' do
        expect(Kommando.new("").out).to eq ""
      end

      it 'has the stdout' do
        expect(completed_uptime_kommand.out).to match /\d+ users, load averages:/
      end
    end

    describe 'when output enabled' do
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

        sleep 0.1 #TODO: how to test

        contents = File.read outfile.path
        expect(contents).to match /\d+ users, load averages:/
      end

      it 'flushes in sync' do
        pending "how to test properly?"
        fail
      end
    end

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

  end

end
