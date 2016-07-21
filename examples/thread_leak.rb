require "./lib/kommando"

100.times do
  k = Kommando.run "uptime"
  print "."
end
sleep 0.25

raise "Thread leak" unless Thread.list.count == 1
puts "ok"
