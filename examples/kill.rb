require "./lib/kommando"

k = Kommando.new "sleep 10"

Thread.new do
  puts "killer is waiting.."
  sleep 1
  k.kill
  puts "..killed."
end
k.run

raise "not 137" unless k.code == 137

puts "Killed while sleeping, exitcode is 137"
