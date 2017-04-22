require "./lib/kommando"

calls = []
calls_matchdata = []

k = Kommando.new("ping -c 3 -i 0.2 127.0.0.1", {
  output: false
})

k.out.once("bytes") do
  calls << :first
end

k.out.once(/from (\d+)\./) do |m|
  calls_matchdata << m[1]
end

k.run

raise "err" unless calls == [:first]
raise "err matchdata" unless calls_matchdata == ["127"]