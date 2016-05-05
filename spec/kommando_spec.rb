require 'spec_helper'

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

    it 'should raise nice error message when a command is not found' do
      notfound = Kommando.new("thiscommandcanpossiblynotbefoundonthissystemevenin1999 --i-am-pretty-sure")
      expect{notfound.run}.to raise_error(Kommando::Error, "Command 'thiscommandcanpossiblynotbefoundonthissystemevenin1999' not found")
    end

    describe 'args' do
      let(:ping_kommand) { Kommando.new "ping -c 1 127.0.0.1" }

      it 'runs a cmd with arguments' do
        expect(ping_kommand.run).to be true
      end

      it 'calls passes args correctly' do
        ping_kommand.run
        expect(ping_kommand.out).to match /64 bytes from 127.0.0.1/
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
    end

  end

end
