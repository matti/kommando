require "./lib/kommando"

k = Kommando.new "sleep 2", {
  timeout: 0.5
}
k2 = Kommando.new "sleep 2", {
  timeout: 0.5
}

did_run_timeout_callback = false

k.when :timeout do
  did_run_timeout_callback = true
end

k.run
k2.run

if k.code == 1 && k2.code == 1
  puts "timed out"
else
  raise "code not 1"
end

raise "timeout callback not called" unless did_run_timeout_callback
