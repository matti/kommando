require "./lib/kommando"

calls = []
k = Kommando.new("$ exit 0")
k.when(:success) do
  calls << :success
end.when(:exit) do
  calls << :exit
end

k.run

raise "err" unless calls == [:exit, :success]