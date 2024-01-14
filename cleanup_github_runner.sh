#!/usr/bin/env bash

set -euo pipefail

step()
{
    echo "-------------------------------"
    echo "$@"
}

step "current disk size"
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
