require 'spec_helper'
require 'tempfile'

describe Kommando do
  describe 'in' do
    it 'takes input in shell' do
      k = Kommando.new "$ read NAME; echo $NAME", {
        timeout: 0.5
      }
      k.in << "David"
      k.run

      expect(k.out).to eq "David"
    end

    it 'takes input in for a command' do
      tmpfile = Tempfile.new
      k = Kommando.new "nano #{tmpfile.path}", {
        timeout: 0.5
      }
      k.in << "\x1B\x1Bx"
      k.run

      expect(k.code).to eq 0
    end
  end
end
