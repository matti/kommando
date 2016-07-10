require 'spec_helper'
require 'tempfile'

describe Kommando do
  describe 'run' do
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
        k = Kommando.new "echo 1"
        expect(k.run).to eq true
        expect(k.code).to eq 0
        k.wait
        sleep 0.25 #TODO: hnnggh
        expect(k.out).to eq "1\r\n"
      end
    end

    describe 'shell' do
      it 'runs a shell command' do
        shell = Kommando.new "$ echo hello"
        shell.run
        expect(shell.out).to eq "hello"
      end

      it 'runs a shell command with pipes' do
        shell = Kommando.new "$ echo hello | rev"
        shell.run
        expect(shell.out).to eq "olleh"
      end

      it 'runs a shell command without space after $' do
        shell = Kommando.new "$echo hello"
        shell.run
        expect(shell.out).to eq "hello"
      end

      it 'runs a shell command with many spaces after $' do
        shell = Kommando.new "$     echo hello"
        shell.run
        expect(shell.out).to eq "hello"
      end
    end

    describe 'envs' do
      it 'sets ENVs for shell command' do
        k = Kommando.new "$ echo $KOMMANDO_ENV1 $KOMMANDO_ENV2", {
          env: {
            KOMMANDO_ENV1: "hello",
            KOMMANDO_ENV2: "world"
          }
        }
        k.run
        expect(k.out).to eq "hello world"
      end

      it 'sets ENVs for command' do
        outfile = Tempfile.new
        File.unlink(outfile.path)
        expect(File.exist?(outfile.path)).to be false

        k = Kommando.new "touch $KOMMANDO_ENV", {
          env: {
            KOMMANDO_ENV: outfile.path,
          }
        }
        k.run

        expect(k.code).to eq 0
        expect(File.exist?(outfile.path)).to be true
      end

      it 'sets ENVs thataretogether' do
        k = Kommando.new "$ echo $KOMMANDO_ENV1$KOMMANDO_ENV2", {
          env: {
            KOMMANDO_ENV1: "hello",
            KOMMANDO_ENV2: "world"
          }
        }
        k.run
        expect(k.out).to eq "helloworld"
      end
    end

  end
end
