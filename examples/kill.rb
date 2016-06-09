require "./lib/kommando"

k = Kommando.new "sleep 10"

Thread.new do
  puts "killer is waiting.."
  sleep 1
  k.kill
  puts "..killed."
end
k.run

puts "Killed while sleeping."
