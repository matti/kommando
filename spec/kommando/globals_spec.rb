require 'spec_helper'
require 'tempfile'

describe Kommando do
  describe 'globals' do
    after :each do
      Kommando.timeout = nil
    end

    describe 'timeout' do
      it "returns default timeout" do
        expect(Kommando.timeout).to be_nil
      end

      it "can be set" do
        Kommando.timeout = 2
        expect(Kommando.timeout).to equal(2)
      end

      it "affects new instances" do
        Kommando.timeout = 0.0001
        k = Kommando.new "$ sleep 10.4"
        k.run
        timeout_called = false
        k.when :timeout do
          timeout_called = true
        end

        expect(timeout_called).to be_truthy
      end
    end

    describe 'when' do

      after :each do
        Kommando.when = nil
        Kommando.timeout = nil
      end

      it 'can be set' do
        Kommando.when :timeout do
          puts "timeout"
        end
      end

      it 'can not be invalid event name' do
        expect {
          Kommando.when :not_valid_event do
            1
          end
        }.to raise_error(Kommando::Error, "When 'not_valid_event' is not known.")
      end

      it 'will call events' do
        Kommando.timeout = 0.000001

        timeout_called_1, timeout_called_2 = false, false
        Kommando.when :timeout do
          timeout_called_1 = true
        end
        Kommando.when :timeout do
          timeout_called_2 = true
        end

        Kommando.run "$ sleep 1"

        expect(timeout_called_1).to be_truthy
        expect(timeout_called_2).to be_truthy
      end

      it 'will have context available' do
        called = false
        Kommando.when :success do |kontextual_k|
          called = true
          expect(kontextual_k).to be_an_instance_of Kommando
          expect(kontextual_k.instance_variable_get("@cmd")).to eq "uptime"
        end

        Kommando.run "uptime"
        expect(called).to be_truthy
      end
    end
  end
end
