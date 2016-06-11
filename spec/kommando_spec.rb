require 'spec_helper'
require 'tempfile'

describe Kommando do
  it 'has a version number' do
    expect(Kommando::VERSION).not_to be nil
  end

  describe 'initialization' do
    it 'requires cmd as an argument' do
      k = Kommando.new "uptime"
      expect(k).to be_an_instance_of(Kommando)
    end

    it 'accepts additional options as the second argument' do
      k = Kommando.new "uptime", {
        output: true
      }
      expect(k).to be_an_instance_of(Kommando)
    end
  end

end
