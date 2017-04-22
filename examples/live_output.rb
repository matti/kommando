require "./lib/kommando"

Kommando.run "ping -c 3 -i 0.2 127.0.0.1", {
  output: true
}
