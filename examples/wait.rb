require "./lib/kommando"

k = Kommando.run_async "sleep 0.5"
raise "err" if k.code
k.wait
raise "err" unless k.code == 0
