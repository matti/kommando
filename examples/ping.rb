require "./lib/kommando"

k = Kommando.new "ping -c 3 google.com"
k.run

puts k.out
