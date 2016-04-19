require 'spec_helper'

describe Kommando::Buffer do

  describe 'initialization' do
    it 'takes no arguments' do
      expect(Kommando::Buffer.new).to be_an_instance_of(Kommando::Buffer)
    end
  end

  describe 'appending' do
    let(:empty_b) { Kommando::Buffer.new }

    it 'accepts strings' do
      expect(empty_b.append("s")).to be_truthy
    end
  end

  describe 'stringifying' do
    let(:loaded_b) do
      b = Kommando::Buffer.new
      b.append "abcdefghijklmnopqrstuvwxyz"
      b
    end

    it 'returns full contents as a string' do
      expect(loaded_b.to_s).to eq("abcdefghijklmnopqrstuvwxyz")
    end
  end
end
