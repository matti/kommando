require "./lib/kommando"
require "tempfile"

scratch = Tempfile.new

k = Kommando.new "$ printf 'name:'; read N; printf \"lol, $N\"", {
  output: true,
  #latency: 0.5
}

k.out.on "name:" do
  k.in << "hello\n"
  k.out.on "lol" do
    puts "wat"
  end
end

k.run
