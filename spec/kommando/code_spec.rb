require 'spec_helper'
require 'tempfile'

describe Kommando do
  describe 'code' do
    it 'has nil code if not run' do
      notrun = Kommando.new "exit"
      expect(notrun.code).to be nil
    end

    it 'has success code on clean exit' do
      success = Kommando.new "$ true"
      success.run
      expect(success.code).to eq 0
    end

    it 'has error code on not clean exit' do
      failure = Kommando.new "$ false"
      failure.run #TODO: once the code this was 0...?
      expect(failure.code).to eq 1
    end
  end
end
