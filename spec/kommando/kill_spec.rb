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

      expect(Time.now.to_i).to eq time_before
      expect(k.code).to eq 137
    end

    it 'kills the asynchronous run' do
      somefile = Tempfile.new
      File.unlink(somefile.path)
      expect(File.exist?(somefile.path)).to be false

      k = Kommando.new "$ touch #{somefile.path}"

      k.run_async
      Thread.new do
        sleep 0.001 # TODO: expose started attribute
        k.kill
        expect(k.code).to eq 137
      end

      sleep 0.05 # give time to make the file if killing fails

      expect(File.exist?(somefile.path)).to be false
    end
  end
end
