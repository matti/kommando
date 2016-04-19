require 'spec_helper'

describe Kommando do
  it 'has a version number' do
    expect(Kommando::VERSION).not_to be nil
  end

  describe 'initialization' do
    it 'requires cmd as an argument' do
      k = Kommando.new "uptime"
      expect(k).to be_an_instance_of(Kommando)
    end
  end

  describe 'running' do
    let(:uptime_kommand) { Kommando.new "uptime" }

    it 'runs the cmd' do
      expect(uptime_kommand.run).to be_truthy
    end
  end
end
