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
