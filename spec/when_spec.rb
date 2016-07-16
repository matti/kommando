require 'spec_helper'

describe Kommando::When do
  describe 'initialization' do
    it 'takes no arguments' do
      expect(Kommando::When.new).to be_an_instance_of Kommando::When
    end
  end

  describe 'register and fire' do
    it 'registers an event with a lambda and calls it' do
      w = Kommando::When.new
      registered = false

      block = lambda do
        registered = true
      end
      w.register :exit, block

      expect(registered).to be false
      w.fire :exit
      expect(registered).to be true
    end
  end
end
