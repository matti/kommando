require "./lib/kommando"

k = Kommando.new "ping -c 3 127.0.0.1", {
  output: true
}

k.run
