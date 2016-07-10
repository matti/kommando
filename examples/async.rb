require "./lib/kommando"

k = Kommando.run_async "sleep 0.5"
puts "started in background"

while (k.code == nil) do
  print "."
  sleep 0.1
end

puts "exited"
