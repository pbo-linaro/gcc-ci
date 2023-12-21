#!/usr/bin/env bash

set -euo pipefail

echo "current disk size"
df -h .

echo "delete biggest packages"
# list biggest packages with:
# dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n
sudo apt purge -y azure-cli google-cloud-cli microsoft-edge-stable dotnet-* temurin-* google-chrome-stable llvm-* firefox powershell
df -h .

echo "remove /opt/*"
sudo rm -rf /opt/*
df -h .

echo "delete docker images"
docker system prune -af
df -h .

echo "delete android files"
sudo rm -rf /usr/local/lib/android
df -h .

echo "delete haskell (ghc) files"
sudo rm -rf /usr/local/.ghcup
df -h .
