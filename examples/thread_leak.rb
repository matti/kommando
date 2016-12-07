require "./lib/kommando"

Kommando.timeout = 0.1
Kommando.when :timeout do |k|
  print "t"
  puts k.inspect
  exit 1
end

100.times do
  Kommando.run "uptime"
  print "."
end

3.times do
  unless Thread.list.count == 1
    print "w(#{Thread.list.count})"
    sleep 0.01
  else
    break
  end
end

unless Thread.list.count == 1
  puts Thread.list.map(&:inspect).join("\n")
  raise "Thread leak: #{Thread.list.count}"
end

puts "ok"
