require 'spec_helper'
require 'tempfile'

describe Kommando do
  describe 'kill' do
    it 'kills the synchronous run' do
      k = Kommando.new "sleep 10"

      time_before = Time.now.to_i
      Thread.new do
        sleep 0.01 # allow command to start
        k.kill
      end
      k.run

      expect(Time.now.to_i).to be_within(10).of(time_before)
      expect(k.code).to eq 137
    end

    it 'kills the asynchronous run' do
      k = Kommando.run_async "$ echo 1"

      Thread.new do
        sleep 0.001 # TODO: expose started attribute
        k.kill
        expect(k.code).to eq 137
      end

      expect(k.out).to eq ""
    end
  end
end
