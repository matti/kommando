require 'spec_helper'

describe Kommando do
  describe 'shorthands' do
    describe 'run' do
      it 'runs immediately' do
        k = Kommando.run "$ echo hello"
        expect(k.code).to eq 0
        expect(k.out).to eq "hello"
      end

      it 'accepts opts' do
        k = Kommando.run "$ echo hello", {
          timeout: 0.000001
        }
        expect(k.code).to eq 1
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
