require "./lib/kommando"

k = Kommando.run "$ echo hello"
raise "err" unless k.out == "hello"

puts k.out

k = Kommando.run_async "$ echo hello"
sleep 0.1 until k.code == 0  #TODO: k.wait

raise "err" unless k.out == "hello"

puts k.out
