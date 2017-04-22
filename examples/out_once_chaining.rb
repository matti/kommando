require "./lib/kommando"

calls_bytes = []
calls_icmp = []
calls_ttl_then_time = []

k = Kommando.new("ping -c 3 -i 0.2 127.0.0.1", {
  output: true
})

k.out.on("bytes") do
  calls_bytes << :only_bytes
end

k.out.once("icmp_seq") do
  calls_icmp << :first_icmp
end.once("icmp_seq") do
  calls_icmp << :second_icmp
end

k.out.once("ttl").once("time") do
  calls_ttl_then_time << :only_ttl_then_time
end

k.run

raise "err icmp" unless calls_icmp == [:first_icmp, :second_icmp]
raise "err bytes" unless calls_bytes == [:only_bytes]
raise "err ttl_then_time" unless calls_ttl_then_time == [:only_ttl_then_time]