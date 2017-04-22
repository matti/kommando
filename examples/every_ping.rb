require "./lib/kommando"

calls = []

k = Kommando.new("ping -c 2 -i 0.2 127.0.0.1", {
  output: false
})

k.out.every(/from (\d+\.\d+\.\d+\.\d+):/) do |m|
  calls << m[1]
end

k.run

raise "err" unless calls == ["127.0.0.1", "127.0.0.1"]
