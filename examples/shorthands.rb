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


Kommando.timeout = 0.0002
Kommando.when :timeout do
  puts "Global when timeout 1"
end
Kommando.when :timeout do
  puts "Global when timeout 2"
end

Kommando.run "$ sleep 10"

Kommando.timeout = nil
Kommando.when = nil

Kommando.when :success do
  puts "succes callback"
end

Kommando.when :failed do
  puts "failed callback"
end

Kommando.when :exit do
  puts "exit callback"
end

Kommando.run "$ exit 0"
Kommando.run "$ exit 1"
