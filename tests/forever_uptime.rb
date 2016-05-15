require "./lib/kommando"

puts "Running forever..."

iterations = 0
while true do
  k = Kommando.new "uptime", {
    retry: true  # TODO: make this pass without true
  }
  k.run

  unless k.out.size > 60
    puts k.out
    raise "uptime output doesn't have enough content"
  end

  iterations += 1
  if iterations % 100 == 0
    print "."
  end
end
