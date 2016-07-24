require "./lib/kommando"
require 'stackprof'


profile = StackProf.run(mode: :wall, out: 'tmp/stackprof-wall.dump', interval: 100) do
  100.times {
    Kommando.run "uptime"
  }
end

profile = StackProf.run(mode: :cpu, out: 'tmp/stackprof-cpu.dump', interval: 100) do
  100.times {
    Kommando.run "uptime"
  }
end

Kommando.puts "stackprof tmp/stackprof-wall.dump --text"
Kommando.puts "stackprof tmp/stackprof-cpu.dump --text"
