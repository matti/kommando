require 'spec_helper'

describe Kommando do
  describe 'when' do
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

    it 'runs block when process has exited' do
      exit_called = false

      k = Kommando.new "uptime"
      k.when :exit do
        exit_called = true
      end
      k.run

      expect(exit_called).to be true
    end

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

    it 'runs blocks given with strings' do
      start_called = false

      k = Kommando.new "uptime"
      k.when "start" do
        start_called = true
      end
      k.run

      expect(start_called).to be true
    end

    describe 'multiple' do
      it 'runs multiple blocks when process has started' do
        start1_called = false
        start2_called = false

        run_completed = false

        k = Kommando.new "uptime"
        k.when :start do
          start1_called = true
          expect(run_completed).to be false
        end
        k.when :start do
          start2_called = true
          expect(run_completed).to be false
        end

        k.run
        run_completed = true

        expect(start1_called).to be true
        expect(start2_called).to be true
      end
    end

  end
end
