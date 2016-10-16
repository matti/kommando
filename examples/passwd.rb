require "./lib/kommando"

script = '
printf "new password: "
read input1
printf "password again: "
read input2

if [ "$input1" == "$input2" ]; then
  printf "Are you sure that you want to change it? (y/N): "
  read input3
  if [ "$input3" == "y" ]; then
    echo "changed"
  else
    echo "not changed"
  fi
else
  echo "Passwords did not match"
fi
'

k = Kommando.new "$ #{script}", {
  output: true
}

k.out.on "new password:" do
  k.in.write "lol\r"

  k.out.on "password again:" do
    k.in.writeln "lol"

    k.out.on /want to change it\?/ do
      k.in << "y\r"
    end

    k.out.on /Passwords did not match/ do
      raise "this should never happen with that script."
    end
  end
end

k.run
