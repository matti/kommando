require "./lib/kommando"

calls = []
k = Kommando.new("ping -c 3 127.0.0.1", {
  output: true
})

k.out.once("bytes") do
  calls << :first
end

k.run

raise "err" unless calls == :first