require 'spec_helper'

describe Kommando do
  describe 'out' do
    describe 'once' do
      it 'matches just one hello' do
        k = Kommando.new "$ echo hello hello"
        calls = []
        k.out.once /hello/ do
          calls << :hello
        end
        k.run

        expect(calls).to eq([:hello])
      end

      describe 'chaining' do
        it 'can chain matches' do
          k = Kommando.new "$ echo hello hello"
          calls = []
          k.out.once /hello/ do
            calls << :hello1
          end.once /hello/ do
            calls << :hello2
          end
          k.run

          expect(calls).to eq([:hello1, :hello2])
        end

        it 'only does not match extra' do
          k = Kommando.new "$ echo hello hello hello"
          calls = []
          k.out.once /hello/ do
            calls << :hello1
          end.once /hello/ do
            calls << :hello2
          end
          k.run
          expect(calls).to eq([:hello1, :hello2])
        end

        it 'only calls nested onces in order if they matchbin/au' do
          k = Kommando.new "$ echo hello1 hello2 hello2"
          calls = []
          k.out.once /hello1/ do
            calls << :hello1
          end

          k.out.once /hello2/ do
            calls << :hello2_first
          end.once /hello2/ do
            calls << :hello2_second
          end

          k.run
          expect(calls).to eq([:hello1, :hello2_first, :hello2_second])
        end

        it 'can have empty blocks' do
          k = Kommando.new "$ echo hello1 hello2 hello3"
          calls = []
          k.out.once(/hello1/).once(/hello2/).once(/hello3/) do
            calls << :last_hello
          end

          k.run
          expect(calls).to eq([:last_hello])
        end

      end
    end
  end
end
