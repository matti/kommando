require "./lib/kommando"

k = Kommando.run_async "sleep 10"

sleep 0.1
k.kill
puts "..killed."

raise "not 137" unless k.code == 137

puts "Killed while sleeping, exitcode is 137"
