require "./lib/kommando"

k_in_when, k_in_out_on = nil, nil

k = Kommando.new "$ echo something"
k.when(:exit) do #NOTE: no |k| needed (naturally)
  k_in_when = true if k
end
k.out.on("something") do
  k_in_out_on = true if k
end

k.run

raise "err" unless k_in_when && k_in_out_on