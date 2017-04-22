require "./lib/kommando"
require "tempfile"

outfile = Tempfile.new "test"

k = Kommando.new "ping -c 3 -i 0.2 127.0.0.1", {
  output: outfile.path
}

Thread.abort_on_exception=true
t = Thread.new do
  Kommando.new "tail -f #{outfile.path}", {
    output: true
  }
end

k.run
t.kill

puts File.read outfile.path
