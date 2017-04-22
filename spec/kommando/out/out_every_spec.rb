require 'spec_helper'

describe Kommando do
  describe 'out' do
    describe 'every' do
      it 'matches every hello' do
        k = Kommando.new "$ echo hello hello"
        calls = []
        k.out.every /hello/ do
          calls << :hello
        end
        k.run

        expect(calls).to eq([:hello, :hello])
      end

      describe 'chaining' do
        it 'can be chained' do
          k = Kommando.new "$ echo hello hello"
          calls = []
          k.out.every /hello/ do
            calls << :hello
          end.every /hell/ do
            calls << :hell
          end
          k.run

          expect(calls).to eq([:hello, :hell, :hello])
        end
      end

      describe 'MatchData' do
        it 'calls the proc with the MatchData' do
          k = Kommando.new "$ echo hello hello"
          calls = []
          k.out.every /(hello)/ do |m|
            calls << m[1]
          end
          k.run

          expect(calls).to eq(["hello", "hello"])
        end
      end
    end
  end
end
