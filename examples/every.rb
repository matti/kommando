require "./lib/kommando"

calls = []
calls_chained = []

k = Kommando.new("$ echo hello hello hello hell", {
  output: false
})

k.out.every("hello") do
  calls << :got_hello
end

k.out.every("hello") do
  calls_chained << :got_hello
end.every("hell") do
  calls_chained << :got_hell
end

k.run

raise "err" unless calls == [:got_hello, :got_hello, :got_hello]
raise "err chained" unless calls_chained == [:got_hello, :got_hell, :got_hello, :got_hell, :got_hello, :got_hell]