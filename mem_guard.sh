#!/bin/bash

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

  if [ "${#log_buffer[@]}" -gt "$LOG_LINES" ]; then
    log_buffer=("${log_buffer[@]:1}")
  fi

  printf "%s\n" "${log_buffer[@]}" > "$LOG_FILE"
}

while true; do
  read used max percent <<< $(get_mem_info)

  add_log "RAM ${used}/${max}MB (${percent}%)"

  sleep 1
done
