require 'spec_helper'

describe Kommando do
  it 'has a version number' do
    expect(Kommando::VERSION).not_to be nil
  end

  it 'can be instantiated' do
    expect(Kommando.new).to be_an_instance_of(Kommando)
  end
end
