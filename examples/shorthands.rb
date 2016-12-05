require "./lib/kommando"

k = Kommando.run "$ echo hello"
raise "err" unless k.out == "hello"

puts k.out

k = Kommando.run_async "$ echo hello"
k.wait

raise "err" unless k.out == "hello"

Kommando.puts "$ echo ok"

k = Kommando.puts "$ sleep 10", {
  timeout: 0.00001
}

k.when :timeout do
  puts "did timeout as expected."
end

Kommando.timeout = 0.0001
k = Kommando.new "$ sleep 10"
k.when :timeout do
  puts "did timeout as expected with global timeout #{Kommando.timeout}"
end
k.run
