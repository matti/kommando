require 'spec_helper'

describe Kommando do
  describe 'wait' do
    it 'blocks until process exits' do
      k = Kommando.run_async "uptime"
      k.wait
      expect(k.code).to eq 0
      expect(k.out).to match "load averages"
    end

    it 'does not block if not async' do
      k = Kommando.run "uptime"

      time_before = Time.now
      k.wait
      expect(time_before).to be_within(0.001).of(Time.now)
    end
  end
end
