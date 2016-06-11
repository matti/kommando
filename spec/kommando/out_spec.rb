require 'spec_helper'
require 'tempfile'

describe Kommando do
  describe 'out' do
    it 'is empty if not run' do
      expect(Kommando.new("").out).to eq ""
    end

    it 'has the stdout' do
      uptime = Kommando.new "uptime"
      uptime.run
      uptime

      expect(uptime.out).to match /\d+ users, load averages:/
    end
  end
end
