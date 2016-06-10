require "./lib/kommando"

k = Kommando.new "$ echo 'hello\nworld' | rev | rev"
k.run

raise "err" unless k.out == "hello\r\nworld"
puts "shell says: #{k.out}"
