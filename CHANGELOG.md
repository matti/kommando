# CHANGELOG

## 0.0.15
When exit callbacks

- FEAT: Callback `k.when :exit block`
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
