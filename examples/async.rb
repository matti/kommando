require "./lib/kommando"

k = Kommando.new "sleep 1"

exited = false
k.when "exit" do
  exited = true
end

k.run_async
puts "started in background"


until (exited) do
  print "."
  sleep 0.1
end

puts "exited"
