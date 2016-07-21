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

      it 'does not run unless timeouts' do
        timeout_called = false

        k = Kommando.new "uptime"
        k.when :timeout do
          timeout_called = true
        end
        k.run

        expect(timeout_called).to be false
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

    describe 'error' do

      it 'runs error, exit callbacks on RuntimeError "can\'t get Master/Slave device" and supress' do
        error_called = false
        exit_called = false
        k = Kommando.new "uptime"

        allow(PTY).to receive(:spawn).and_raise(RuntimeError, "can't get Master/Slave device")

        k.when :error do
          error_called = true
        end
        k.when :exit do
          exit_called = true
        end

        k.run

        expect(error_called).to be true
        expect(exit_called).to be true
      end

      it 'runs error, exit callback on exception ThreadError "can\'t create Thread: Resource temporarily unavailable" and raise' do
        error_called = false
        exit_called = false
        k = Kommando.new "uptime"

        allow(PTY).to receive(:spawn).and_raise(ThreadError, "can't create Thread: Resource temporarily unavailable")

        k.when :error do
          error_called = true
        end
        k.when :exit do
          exit_called = true
        end
        expect {
          k.run
        }.to raise_error ThreadError, "can't create Thread: Resource temporarily unavailable"

        expect(error_called).to be true
        expect(exit_called).to be true
      end

      it 'runs error callback on non existing command and raise' do
        error_called = false

        k = Kommando.new "not_existing_command_with non_existing_args"
        k.when :error do
          error_called = true
        end

        expect {
          k.run
        }.to raise_error(Kommando::Error, "Command 'not_existing_command_with' not found")

        expect(error_called).to be true
      end
    end

    describe 'retry' do
      it 'runs retry callback on exception ThreadError "can\'t create Thread: Resource temporarily unavailable" and succeeds on third time' do
        retry_called_times = 0

        k = Kommando.new "uptime", {
          retry: {
            times: 3
          }
        }

        mock_pty = class_double("PTY")
        expect(mock_pty).to receive(:spawn).exactly(2).times.and_raise(ThreadError, "can't create Thread: Resource temporarily unavailable")

        k.define_singleton_method(:make_pty_testable) do
          pty_for_this_time = if @retry_time > 1
            mock_pty
          else
            PTY
          end

          pty_for_this_time
        end

        k.when :retry do
          retry_called_times += 1
        end
        k.run

        expect(retry_called_times).to eq 2
        expect(k.out).to match /load averages/
      end

      it 'runs retry callback on exception ThreadError "can\'t create Thread: Resource temporarily unavailable" and with sleep in between and succeeds on the third time' do
        k = Kommando.new "uptime", {
          retry: {
            times: 3,
            sleep: 0.1
          }
        }

        k.define_singleton_method(:make_pty_testable) do
          if @retry_time > 1
            raise ThreadError, "can't create Thread: Resource temporarily unavailable"
          else
            PTY
          end
        end

        started = Time.now
        times_between_retries = []
        k.when :retry do
          times_between_retries << (Time.now - started).to_f.round(1)
        end

        k.run
        expect(times_between_retries).to eq [0.1,0.2]
        expect(k.code).to eq 0
      end
    end

    describe 'order' do
      it 'retry, retry, start, exit' do
        order = []

        k = Kommando.new "uptime", {
          retry: {
            times: 3
          }
        }

        mock_pty = class_double("PTY")
        expect(mock_pty).to receive(:spawn).exactly(2).times.and_raise(ThreadError, "can't create Thread: Resource temporarily unavailable")

        k.define_singleton_method(:make_pty_testable) do
          pty_for_this_time = if @retry_time > 1
            mock_pty
          else
            PTY
          end

          pty_for_this_time
        end

        k.when :start do
          order << :start
        end
        k.when :retry do
          order << :retry
        end
        k.when :exit do
          order << :exit
        end

        k.run

        expect(order).to eq [:retry, :retry, :start, :exit]
      end

      it 'retry, retry, start, exit' do
        order = []

        k = Kommando.new "uptime", {
          retry: {
            times: 3
          }
        }

        expect(PTY).to receive(:spawn).exactly(4).times.and_raise(ThreadError, "can't create Thread: Resource temporarily unavailable")

        k.when :start do
          order << :start #never
        end
        k.when :retry do
          order << :retry
        end
        k.when :error do
          order << :error
        end
        k.when :exit do
          order << :exit
        end
        expect {
          k.run
        }.to raise_error ThreadError, "can't create Thread: Resource temporarily unavailable"

        expect(order).to eq [:retry, :retry, :retry, :error, :exit]
      end

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

      it 'error, exit' do
        order = []

        k = Kommando.new "uptime", {
          timeout: 0.001
        }
        allow(PTY).to receive(:spawn).and_raise(ThreadError, "can't create Thread: Resource temporarily unavailable")

        k.when :start do
          order << :start #never
        end
        k.when :exit do
          order << :exit
        end
        k.when :error do
          order << :error
        end

        expect {
          k.run
        }.to raise_error ThreadError, "can't create Thread: Resource temporarily unavailable"

        expect(order).to eq [:error, :exit]
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

    describe 'event names' do
      it 'validates' do
        k = Kommando.new "uptime"
        expect {
          k.when :not_valid_event do
            1
          end
        }.to raise_error(Kommando::Error, "When 'not_valid_event' is not known.")
      end
    end

  end
end
