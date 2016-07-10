require "./lib/kommando"

k = Kommando.new "$ (>&2 echo 'err'); echo 'out'"
k.run

raise "err" unless k.out == "err\r\nout"
puts k.out
