require "./lib/kommando"

k = Kommando.run "uptime"

puts k.out
