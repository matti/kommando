require "./lib/kommando"

k = Kommando.new "sleep 2", {
  timeout: 0.5
}
k2 = Kommando.new "sleep 2", {
  timeout: 0.5
}

k.run
k2.run

if k.code == 1 && k2.code == 1
  puts "timed out"
end
