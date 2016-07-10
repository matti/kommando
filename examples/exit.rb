require "./lib/kommando"

failure = Kommando.run "false"

puts "Failure error: #{failure.code}"

success = Kommando.run "true"

puts "Success error: #{success.code}"
