require "./lib/kommando"

k = Kommando.new "uptime"
k.run

puts k.out
