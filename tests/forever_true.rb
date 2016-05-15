require "./lib/kommando"

puts "Running forever..."
while true do
  k = Kommando.new "/usr/bin/true"
  k.run
  unless k.code == 0
    raise "true failed..."
  end
  
  print "."
end
