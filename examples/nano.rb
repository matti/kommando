require "./lib/kommando"
require "tempfile"

scratch = Tempfile.new "test"

k = Kommando.new "nano #{scratch.path}", {
  output: true
}

Thread.new do
  words = [
    "hello\r",
    "world\r",
    "\x1B\x1Bx",
    "y",
    "\r"
  ]
  words.each do |word|
    k.in << word
    sleep 0.25
  end
end

k.run

`reset`  #TODO: how to reset in kommando?
