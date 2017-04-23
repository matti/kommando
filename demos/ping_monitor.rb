# $ ruby demos/ping_monitor.rb 
# 0.077 xxxxxxxxxxxxxxxxxxxxxxx
# 0.021 xxxxxx
# 0.027 xxxxxxxx
# 0.021 xxxxxx
# 0.021 xxxxxx
# 0.041 xxxxxxxxxxxx
# 0.021 xxxxxx
# 0.023 xxxxxx
# ^C

require "./lib/kommando"

k = Kommando.new "ping -i 0.2 127.0.0.1"

k.out.every /time=(\d+\.\d+)\s/ do |m|
  time = m[1].to_f
  print "#{time} ".ljust(6)
  puts "x" * (time*300.to_i)
end

k.out.once(/^PING.+\n$/).every(/^(.+)\r\n/) do |m|
  unless m[1].start_with? "64 bytes from"
    puts "ERR: unexpected reply: #{m[1]}"
    exit 1
  end
end


k.run
