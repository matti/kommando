require 'spec_helper'
require 'tempfile'

describe Kommando do
  describe 'in' do
    describe '<<' do
      it 'takes input in shell' do
        k = Kommando.new "$ read NAME; echo Hello: $NAME", {
          timeout: 0.5
        }
        k.in << "David\r"
        k.run

        expect(k.out).to eq "David\r\nHello: David"
      end

      it 'takes input in for a command' do
        tmpfile = Tempfile.new "test"
        k = Kommando.new "nano #{tmpfile.path}", {
          timeout: 0.5
        }
        k.in << "\x1B\x1Bx"
        k.run

        expect(k.code).to eq 0
      end
    end

    describe "write" do
      it 'takes input in shell' do
        k = Kommando.new "$ read NAME; echo Hello: $NAME", {
          timeout: 0.5
        }
        k.in.write "David\r"
        k.run

        expect(k.out).to eq "David\r\nHello: David"
      end
    end

    describe "writeln" do
      it 'takes input in shell' do
        k = Kommando.new "$ read NAME; echo Hello: $NAME", {
          timeout: 0.5
        }
        k.in.writeln "David"
        k.run

        expect(k.out).to eq "David\r\nHello: David"
      end
    end
  end
end
