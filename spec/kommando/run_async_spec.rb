require 'spec_helper'
require 'tempfile'

describe Kommando do
  describe 'run_async' do
    it 'starts in background' do
      k = Kommando.new "sleep 10"

      time_before = Time.now.to_i
      k.run_async
      expect(Time.now.to_i).to eq time_before
    end
  end
end
