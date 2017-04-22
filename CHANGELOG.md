# CHANGELOG

## x
- FEAT: MatchData will be passed as the first argument of the proc on `k.once` and `k.every`
- FEAT: `k.every` matching with chaining
- FEAT: `k.once` matching with chaining (will deprecate `k.on`)
- FEAT: Ruby 2.1 compatibility
- FEAT: `k.when` returns `k` so when's can be defined as a chain
- FIX: Ruby 2.4 Fixnum deprecation warning

## 0.0.22
- FEAT: Global whens with `Kommando.when :timeout block` and clearing with `Kommando.when = nil`
- FEAT: Context available with `k.when :timeout do |kontextual_k|` and `Kommando.when :timeout |kontextual_k|`
- FEAT: Global timeout with `Kommando.timeout = 1` and `puts Kommando.timeout`
- FEAT: Callback `k.when :success` if command was run and exited with zero status
- FEAT: Callback `k.when :failed` if command did not run or exited with non-zero status
- FIX: `Kommando.puts` shorthand did not return an instance

## 0.0.21
- FEAT: `k.in.write` as an alias for `k.in <<`
- FEAT: `k.in.writeln` as an shorthand for `k.in.write "lol\r"`

## 0.0.20
- FEAT: Run when callbacks immediately if the event already fired.

## 0.0.19
Fixes Linux

- FIX: Linux broken. Should run tests in Linux...

## 0.0.18
Fixes thread leak and some hangs.

- FIX: Fixes hang when reading stdout.
- FIX: Thread leak.

## 0.0.17
Fixes race condition and reduces the number of threads Kommando creates.

- FIX: Race condition when accessing stdout.
- FIX: Do not start thousands of threads with timeout (above)
- FIX: More reliable exit status

## 0.0.16
Error callback, optional retry running.

- FEAT: Retry a certain ThreadError case with `Kommando.run "uptime", {retry: {times: 3}}`
- FEAT: Optionally perform sleep before the retry with `Kommando.run "uptime", {retry: {times: 3, sleep: 2}}`
- FEAT: Callback names are validated.
- FEAT: Callback `k.when :error block` on all known and unknown error states.
- EXAMPLES: `when.rb` updated

## 0.0.15
Exit and timeout callbacks, output shorthand.

- FEAT: Shorthand `Kommando.puts "uptime"`
- FEAT: Callback `k.when :exit block`
- FEAT: Callback `k.when :timeout block`
- EXAMPLES: `async.rb`

## 0.0.14
When callbacks

 - FEAT: Callback `k.when "start" block`
 - EXAMPLES: `when.rb`

## 0.0.13
Shorthands for run and run_async, blocking until completed.

 - FEAT: Immediate run with `Kommando.run "uptime", {}`
 - FEAT: Immediate run_async with `Kommando.run_async "uptime", {}`
 - FEAT: Block until command completes with `k.wait`
 - EXAMPLES: `shorthands.rb` and `wait.rb`

## 0.0.12
Support for matching out and running code on match.

 - FEAT: Out matching with `out.on /regexp/, block`.
 - EXAMPLES: `stderr_to_out.rb`, `in_shell.rb` and `nano_match.rb`

## 0.0.11
STDIN support.

 - FEAT: Support for writing to STDIN with `k.in << "hello"`
 - EXAMPLES: `in` and `nano` added.

## 0.0.10
ENV variable interpolation.

 - FEAT: Support for ENV variables like `Kommando.new "$ echo $HELLO", { env: { HELLO: "world" } }`
 - EXAMPLES: `env` added.

## 0.0.9
Support for shell (bash) commands.

 - FEAT: Support for running shell commands with `Kommando.new "$ echo hello | rev"`
 - EXAMPLES: `shell` added.

## 0.0.8
Improves killing, tries to fix Linux specific issues.

 - FIX: Killed process has status code 137.
 - MAYBEFIX: Linux: undefined method `exitstatus' for nil:NilClass (NoMethodError)`

## 0.0.7
Async running, killing the run.

 - FEAT: Support async running with `k.run_async`
 - FEAT: Support for killing the process.
 - EXAMPLES: `async` and `kill` added.

## 0.0.6
Fix Linux harder.

 - FIX: Changed strategy.

## 0.0.5
Fixes.

 - FIX: File output is flushed in sync.
 - FIX: Linux compatibility attempt.

## 0.0.4
Writes standard out to file and timeouts.

 - FEAT: Support for command run timeouts with `Kommando.new "ping -c 1 google.com", timeout: 3.5`
 - FEAT: Write output to file with `Kommando.new "ping -c 1 google.com", output: "path/to/file.txt"`
 - EXAMPLES: `stdout_to_file` and `timeout` added.

## 0.0.3
Outputs to standard out while executing.

 - FEAT: Output with `Kommando.new "ping -c 1 google.com", output: true`
 - EXAMPLES: `live_output` added.

## 0.0.2
Actually useful initial release.

 - FEAT: Runs commands with arguments `Kommando.new "ping -c 1 google.com"`
 - FEAT: Captures error code in `k.code`
 - EXAMPLES: `ping` and `exit` added.

## 0.0.1
Initial release.

 - FEAT: Runs command without arguments.
 - FEAT: Records the standard out in `k.out`
 - EXAMPLES: `uptime`
