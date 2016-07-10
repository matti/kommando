require "./lib/kommando"

Kommando.run "ping -c 3 127.0.0.1", {
  output: true
}
