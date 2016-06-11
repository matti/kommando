require "./lib/kommando"

k = Kommando.new "$ read YOURNAME; echo hello $YOURNAME"
k.in << "Matti\n"
k.run

raise "err" unless k.out == "Matti\r\nhello Matti"

puts k.out
