require 'spec_helper'

describe Kommando do
  describe 'shorthands' do
    describe 'puts' do
      it 'outputs to stdout' do
        expect {
          Kommando.puts "$ echo hello"
        }.to output(/^hello$/).to_stdout
      end
    end

    describe 'run' do
      it 'runs immediately' do
        k = Kommando.run "$ echo hello"
        expect(k.code).to eq 0
        expect(k.out).to eq "hello"
      end

      it 'accepts opts' do
        expect {
          k = Kommando.run "$ echo hello", {
            output: true
          }
        }.to output(/hello/).to_stdout
      end
    end

    describe 'run_async' do
      it 'starts immediately' do
        k = Kommando.run_async "$ echo hello"
        expect(k.code).to be nil
        expect(k.out).to eq ""

        k.wait

        expect(k.code).to eq 0
        expect(k.out).to eq "hello"
      end

      it 'accepts opts' do
        expect {
          k = Kommando.run_async "$ echo hello", {
            output: true
          }
          k.wait
        }.to output(/hello/).to_stdout
      end
    end
  end
end
