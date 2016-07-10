require "./lib/kommando"

k = Kommando.run "ping -c 3 google.com"
puts k.out
