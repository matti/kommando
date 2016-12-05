require 'spec_helper'
require 'tempfile'

describe Kommando do
  describe 'globals' do
    describe 'timeout' do
      after(:each) do
        Kommando.timeout = nil
      end

      it "returns default timeout" do
        expect(Kommando.timeout).to be_nil
      end

      it "can be set" do
        Kommando.timeout = 2
        expect(Kommando.timeout).to equal(2)
      end

      it "affects new instances" do
        Kommando.timeout = 0.0001
        k = Kommando.new "$ sleep 10"
        k.run
        timeout_called = false
        k.when :timeout do
          timeout_called = true
        end

        expect(timeout_called).to be_truthy
      end
    end
  end
end
