require "./lib/kommando"

k = Kommando.run "$ echo hello"
raise "err" unless k.out == "hello"

puts k.out
