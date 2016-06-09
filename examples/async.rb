require "./lib/kommando"

k = Kommando.new "sleep 0.5"
k.run_async

puts "started in background"

while (k.code == nil) do
  print "."
  sleep 0.1
end

puts "exited"
