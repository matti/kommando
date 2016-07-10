require "./lib/kommando"

k = Kommando.run "$ echo $KOMMANDO_ENV1 $KOMMANDO_ENV2", {
  env: {
    KOMMANDO_ENV1: "hello",
    KOMMANDO_ENV2: "world"
  }
}

raise "err" unless k.out == "hello world"
puts k.out
