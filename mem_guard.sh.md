# Làm bộ cài GitHub siêu nhẹ cho memcon (không cần npm/node)

Mục tiêu:

User chỉ cần chạy:

```bash id="2m8q4x"
curl -sL https://raw.githubusercontent.com/tylaujjapan0/memcon/main/install.sh | bash
```

và:

* tự cài
* tự start monitor
* có lệnh:

  * `ram`
  * `ram.mem`

KHÔNG cần:

* npm
* nodejs
* npx

---

# 1. Xóa hướng npm phức tạp

Trong repo GitHub chỉ giữ:

```txt id="7m5q1x"
memcon/
├── install.sh
├── mem_guard.sh
├── ram
├── ram.mem
└── README.md
```

---

# 2. Tạo `mem_guard.sh`

Trong `/opt/memcon`:

```bash id="8q2m4x"
nano mem_guard.sh
```

Dán:

```bash id="4m7q1x"
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
```

---

# 3. Tạo command `ram`

```bash id="9m1q7x"
nano ram
```

Dán:

```bash id="2x8m5q"
#!/bin/bash
watch -n 1 cat /opt/mem.log
```

---

# 4. Tạo command `ram.mem`

```bash id="6m4q2x"
nano ram.mem
```

Dán:

```bash id="7q1m8x"
#!/bin/bash
tail -f /opt/mem.log
```

---

# 5. Tạo `install.sh`

```bash id="3m8q1x"
nano install.sh
```

Dán:

```bash id="1x7m5q"
#!/bin/bash

set -e

REPO="https://raw.githubusercontent.com/tylaujjapan0/memcon/main"

echo "Installing memcon..."

curl -fsSL $REPO/mem_guard.sh -o /usr/local/bin/mem_guard.sh
curl -fsSL $REPO/ram -o /usr/local/bin/ram
curl -fsSL $REPO/ram.mem -o /usr/local/bin/ram.mem

chmod +x /usr/local/bin/mem_guard.sh
chmod +x /usr/local/bin/ram
chmod +x /usr/local/bin/ram.mem

if pgrep -f mem_guard.sh >/dev/null; then
  echo "mem_guard already running"
else
  nohup /usr/local/bin/mem_guard.sh > /dev/null 2>&1 &
  echo "mem_guard started"
fi

echo ""
echo "Installed!"
echo ""
echo "Commands:"
echo "ram"
echo "ram.mem"
```

---

# 6. Cho executable

```bash id="4m2q8x"
chmod +x install.sh
chmod +x mem_guard.sh
chmod +x ram
chmod +x ram.mem
```

---

# 7. Xóa npm files (không cần nữa)

```bash id="8m5q1x"
rm -f package.json
rm -f index.js
```

---

# 8. Push GitHub

```bash id="2q7m4x"
git add .
git commit -m "convert to lightweight bash installer"
git push
```

---

# 9. Test install toàn cầu

Trên máy mới:

```bash id="5m8q2x"
curl -sL https://raw.githubusercontent.com/tylaujjapan0/memcon/main/install.sh | bash
```

---

# 10. Dùng

```bash id="7m1q5x"
ram
```

hoặc:

```bash id="1m8q4x"
ram.mem
```

---

# 11. Ưu điểm cách này

## Cực nhẹ

Chỉ vài KB.

---

## Cài cực nhanh

1–2 giây.

---

## Không dependency

Không cần:

* node
* npm
* python
* build tools

---

## Linux server nào cũng chạy

* Debian
* Ubuntu
* Alpine
* Docker
* VPS

---

# 12. Sau này update

Sửa file → push GitHub.

User reinstall:

```bash id="9m2q6x"
curl -sL ... | bash
```

là lấy bản mới.
