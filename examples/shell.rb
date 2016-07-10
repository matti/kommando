require "./lib/kommando"

k = Kommando.run "$ echo 'hello\nworld' | rev | rev"

raise "err" unless k.out == "hello\r\nworld"
puts "shell says: #{k.out}"
