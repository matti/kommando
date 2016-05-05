# CHANGELOG

## 0.0.next
Writes standard out to file.

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
