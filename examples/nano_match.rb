require "./lib/kommando"
require "tempfile"

scratch = Tempfile.new

k = Kommando.new "nano #{scratch.path}", {
  output: true
}
k.out.on "GNU nano" do
  k.in << "hello\r"
  k.in << "\x1B\x1Bx"

  k.out.on "Save modified buffer" do
    k.in << "y"

    k.out.on "File Name to Write" do
      k.in << "\r"
    end
  end
end

k.run

`reset` #TODO: reset in kommando
