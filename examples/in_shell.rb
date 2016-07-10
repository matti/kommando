require "./lib/kommando"

k = Kommando.new "$ printf 'name: '; read N; printf \"lol, $N\n\"", {
  output: true
}

k.out.on "name: " do
  k.out.on /^lol, [^\n]+\r\n/ do
    puts "Matched 'lol, USERINPUT\\r\\n' on stdout"
  end

  k.in << "hello\n"

end

k.run
