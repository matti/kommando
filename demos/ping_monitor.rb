require "./lib/kommando"

k = Kommando.new "ping -i 0.2 127.0.0.1"

k.out.every /time=(\d+\.\d+)\s/ do |m|
  time = m[1].to_f
  print "#{time} ".ljust(6)
  puts "x" * (time*300.to_i)
end

k.run
