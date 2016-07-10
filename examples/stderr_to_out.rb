require "./lib/kommando"

k = Kommando.run "$ (>&2 echo 'err'); echo 'out'"

raise "err" unless k.out == "err\r\nout"
puts k.out
