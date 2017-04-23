# Kommando
[![Build Status](https://travis-ci.org/matti/kommando.svg?branch=master)](https://travis-ci.org/matti/kommando)

Command runner with expect-like features. Great for integration testing.

## Usage

### Automating GNU nano:

```
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
    sleep 1
    k.in << "y"

    k.out.on "File Name to Write" do
      sleep 1
      k.in << "\r"
    end
  end
end

k.when "start" do
  puts "Kommando started running nano"
  sleep 2
end

k.when "exit" do
  puts "Kommando finished"
  sleep 1
end

k.run
```

### Shell scripting

```
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
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kommando'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kommando


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake` to run the specs. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

`bin/e2e` runs all Kommando files in `examples/` with `kommando`.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bin/release`, which will run all tests, create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Notes

```
RSPEC_PROFILE=each rake spec
RSPEC_PROFILE=all rake spec
# --> profiles directory
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/matti/kommando.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
