#!/usr/bin/env bash

set -euo pipefail

step()
{
    echo "-------------------------------"
    echo "$@"
}

step "current disk size"
df -h .

step "delete biggest packages"
# list biggest packages with:
# dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n
sudo apt purge -y azure-cli google-cloud-cli microsoft-edge-stable dotnet-* temurin-* google-chrome-stable llvm-* firefox powershell
df -h .

step "remove /opt/*"
sudo rm -rf /opt/*
df -h .

step "delete docker images"
docker system prune -af
df -h .

step "delete android files"
sudo rm -rf /usr/local/lib/android
df -h .

step "delete haskell (ghc) files"
sudo rm -rf /usr/local/.ghcup
df -h .
