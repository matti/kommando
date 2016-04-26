require "./lib/kommando"

failure = Kommando.new "false"
failure.run

puts "Failure error: #{failure.code}"

success = Kommando.new "true"
success.run

puts "Success error: #{success.code}"
