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
          timeout: 0.0001
        }
        expect(k.code).to eq 1
        expect(k.out).to eq ""
      end
    end

    describe 'run_async' do
      it 'starts immediately' do
        k = Kommando.run_async "$ echo hello"
        expect(k.code).to be nil
        expect(k.out).to eq ""

        sleep 0.001 until k.code == 0 #TODO: k.wait

        expect(k.code).to eq 0
        expect(k.out).to eq "hello"
      end

      it 'accepts opts' do
        k = Kommando.run_async "$ echo hello", {
          timeout: 0.0001
        }
        sleep 0.001 until k.code == 1 #TODO: k.wait

        expect(k.code).to eq 1
        expect(k.out).to eq ""
      end
    end
  end
end
