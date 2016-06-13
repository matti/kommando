require "./lib/kommando"
require "tempfile"

scratch = Tempfile.new

k = Kommando.new "nano #{scratch.path}"

puts k.out #tulostaa nanon ruudun

k.out.on "GNU nano" do
  k.in << "hello\r"
  k.in << "\x1B\x1Bx"
end

k.out.on "Save modified buffer" do
  k.in << "y"
  k.in << "\r"
end

k.run
