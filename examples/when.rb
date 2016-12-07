require "./lib/kommando"

k = Kommando.new "$ echo hello"
ended = false
got_start = false
got_exit = false
got_start_when_given_as_symbol = false

k.when "start" do
  got_start = true
  puts "start!"
  raise "code in start" if k.code
  raise "ended in start" if ended
end

k.when :start do
  puts ":start!"
  got_start_when_given_as_symbol = true
end

k.when :exit do
  got_exit = true
end

k.run
ended = true

raise "got_start not set" unless got_start
raise "got_start_when_given_as_symbol not set" unless got_start_when_given_as_symbol
raise "got_exit not set" unless got_exit

k = Kommando.new "not_existing_command_with non_existing_args"

got_error = false
k.when :error do
  puts ":error"
  got_error = true
end

begin
  k.run
rescue
end

raise "got_error not set" unless got_error


k = Kommando.new "thread_not_available_situation_for_example_in_heroku", {
  retry: {
    times: 3
  }
}

k.define_singleton_method :make_pty_testable do
  raise ThreadError, "can't create Thread: Resource temporarily unavailable"
end

got_retry_times = 0
got_error_times = 0
k.when :retry do
  got_retry_times += 1
end
k.when :error do
  got_error_times += 1
end

begin
  k.run
rescue
end

raise "got_retry_times not 3 (is #{got_retry_times})" unless got_retry_times == 3
raise "got_error_times not 1" unless got_error_times == 1


k = Kommando.new "thread_not_available_situation_for_example_in_heroku", {
  retry: {
    times: 1,
    sleep: 0.5
  }
}

k.define_singleton_method :make_pty_testable do
  raise ThreadError, "can't create Thread: Resource temporarily unavailable"
end

started = Time.now
begin
  k.run
rescue
end
delta = (Time.now-started).round(1)
raise "sleep does not work (delta is: #{delta})" unless delta == 0.5
puts "end"


k = Kommando.new "$ sleep 2", {
  timeout: 0.01
}
k.when :timeout do |kk|
  puts kk.inspect
end

k.run

puts "-- Global --"

Kommando.timeout = 0.01
Kommando.when :timeout do |ks|
  puts ks.inspect
end
Kommando.run "$ sleep 2"

puts "--"
Kommando.when :success do |ks|
  puts "out: #{ks.out}"
end

Kommando.run "uptime"
