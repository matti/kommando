require "./lib/kommando"

k = Kommando.run "$ echo hello"
raise "err" unless k.out == "hello"

puts k.out

k = Kommando.run_async "$ echo hello"
k.wait

raise "err" unless k.out == "hello"

puts k.out
