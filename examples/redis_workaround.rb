require "./lib/kommando"

k = Kommando.new "redis-cli --raw", {
  output: true
}

# redis sends cursor position queries (!) even with --raw
k.out.every /\e\[6n/ do |m|
  k.in.write '\e0;0R'
end

got_pong = false
k.out.once "127.0.0.1:6379>" do
  k.in.writeln "ping"
end.once "PONG" do
  got_pong = true
end

k.run_async

# mitigate kommando bug with thread deadlock when writing to in from .every and .once
loop do
  break if got_pong
  sleep 0.1
end
sleep 0.1
k.in.writeln "exit"
k.wait

#Outputs some ANSI trash to terminal when exits (;1R;1R)
