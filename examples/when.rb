require "./lib/kommando"

k = Kommando.new "$ echo hello"
ended = false
got_start = false
got_exit = false
got_start_when_given_as_symbol = false

k.when "start" do
  got_start = true
  puts "start!"
  raise "code in start" if k.code
  raise "ended in start" if ended
end

k.when :start do
  puts ":start!"
  got_start_when_given_as_symbol = true
end

k.when :exit do
  got_exit = true
end

k.run
ended = true

raise "got_start not set" unless got_start
raise "got_start_when_given_as_symbol not set" unless got_start_when_given_as_symbol
raise "got_exit not set" unless got_exit

puts "end"
