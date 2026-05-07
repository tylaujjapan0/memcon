#!/bin/bash

echo "Installing memcon..."

if ! command -v node >/dev/null 2>&1; then
  echo "Installing NodeJS..."

  apt update
  apt install -y nodejs npm
fi

npx @tylaujjapan0/memcon

echo ""
echo "Done!"
echo "Commands:"
echo "ram"
echo "ram.mem"
