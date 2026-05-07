#!/usr/bin/env node

const fs = require("fs");
const { execSync } = require("child_process");

const memGuard = `#!/bin/bash

THRESHOLD=85
LOG_LINES=5
LOG_FILE="/opt/mem.log"

mkdir -p /opt
touch "$LOG_FILE"

log_buffer=()

get_mem_info() {
  max=$(cat /sys/fs/cgroup/memory.max)
  current=$(cat /sys/fs/cgroup/memory.current)

  if [ "$max" = "max" ]; then
    max=$((8 * 1024 * 1024 * 1024))
  fi

  used_mb=$((current / 1024 / 1024))
  max_mb=$((max / 1024 / 1024))
  percent=$((current * 100 / max))

  echo "$used_mb $max_mb $percent"
}

add_log() {
  log_buffer+=("$1")

  if [ "\${#log_buffer[@]}" -gt "$LOG_LINES" ]; then
    log_buffer=("\${log_buffer[@]:1}")
  fi

  printf "%s\\n" "\${log_buffer[@]}" > "$LOG_FILE"
}

while true; do
  read used max percent <<< $(get_mem_info)

  add_log "RAM \${used}/\${max}MB (\${percent}%)"

  sleep 1
done
`;

const ramCmd = `#!/bin/bash
watch -n 1 cat /opt/mem.log
`;

const ramMemCmd = `#!/bin/bash
tail -f /opt/mem.log
`;

fs.writeFileSync("/usr/local/bin/mem_guard.sh", memGuard);
fs.writeFileSync("/usr/local/bin/ram", ramCmd);
fs.writeFileSync("/usr/local/bin/ram.mem", ramMemCmd);

execSync("chmod +x /usr/local/bin/mem_guard.sh");
execSync("chmod +x /usr/local/bin/ram");
execSync("chmod +x /usr/local/bin/ram.mem");

console.log("✅ memcon installed!");

try {
  execSync("pgrep -f mem_guard.sh");
  console.log("mem_guard already running");
} catch {
  console.log("Starting mem_guard...");
  execSync("nohup /usr/local/bin/mem_guard.sh > /dev/null 2>&1 &");
}

console.log("");
console.log("Commands:");
console.log("ram");
console.log("ram.mem");
