require 'spec_helper'

describe Kommando::When do
  describe 'initialization' do
    it 'takes no arguments' do
      expect(Kommando::When.new).to be_an_instance_of Kommando::When
    end
  end
end
