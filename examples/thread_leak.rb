require "./lib/kommando"

last_k = nil
100.times do
  last_k = Kommando.run "uptime", {
    timeout: 0.1
  }
  last_k.when :timeout do
    print "t"
    puts last_k.out
  end
  print "."
end

puts ""
unless Thread.list.count == 1
  puts Thread.list.map(&:inspect).join("\n")
  puts last_k.out
  raise "Thread leak"

end
puts "ok"
