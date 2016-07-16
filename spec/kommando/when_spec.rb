require 'spec_helper'

describe Kommando do
  describe 'when' do

    describe 'start' do
      it 'runs block when process has started' do
        start_called = false
        run_completed = false

        k = Kommando.new "uptime"
        k.when :start do
          start_called = true
          expect(run_completed).to be false
        end
        k.run
        run_completed = true

        expect(start_called).to be true
      end
    end

    describe 'exit' do
      it 'runs block when process has exited' do
        exit_called = false

        k = Kommando.new "uptime"
        k.when :exit do
          exit_called = true
        end
        k.run

        expect(exit_called).to be true
      end
    end

    describe 'timeout' do
      it 'runs block when process timeouts' do
        timeout_called = false

        k = Kommando.new "sleep 10", {
          timeout: 0.01
        }
        k.when :timeout do
          timeout_called = true
        end

        k.run

        expect(timeout_called).to be true
      end
    end

    it 'runs blocks given with strings' do
      start_called = false

      k = Kommando.new "uptime"
      k.when "start" do
        start_called = true
      end
      k.run

      expect(start_called).to be true
    end

    describe 'order' do
      it 'start, timeout, exit' do
        order = []

        k = Kommando.new "uptime", {
          timeout: 0.001
        }
        k.when :exit do
          order << :exit
        end
        k.when :start do
          order << :start
        end
        k.when :timeout do
          order << :timeout
        end

        k.run

        expect(order).to eq [:start, :timeout, :exit]
      end
    end

    describe 'multiple blocks' do
      it 'runs multiple blocks when process has started' do
        start_calls = []
        exit_calls = []

        run_completed = false

        k = Kommando.new "uptime"
        k.when :start do
          start_calls << Time.now
          expect(run_completed).to be false
        end
        k.when :start do
          start_calls << Time.now
          expect(run_completed).to be false
        end
        k.when :exit do
          exit_calls << Time.now
          expect(run_completed).to be false
        end
        k.when :exit do
          exit_calls << Time.now
          expect(run_completed).to be false
        end

        k.run
        run_completed = true

        expect(start_calls.size).to eq 2
        expect(exit_calls.size).to eq 2
      end
    end

  end
end
