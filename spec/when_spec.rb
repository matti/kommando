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

  describe 'register' do
    it 'validates' do
      w = Kommando::When.new
      expect {
        w.register :not_valid_event, nil
      }.to raise_error(Kommando::Error, "When 'not_valid_event' is not known.")
    end
  end

  describe 'fire' do
    it 'validates' do
      w = Kommando::When.new
      expect {
        w.fire :not_valid_event
      }.to raise_error(Kommando::Error, "When 'not_valid_event' is not known.")
    end
  end
end
