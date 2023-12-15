#!/usr/bin/env bash

set -euo pipefail

if [ ! -d gcc ]; then
    git clone https://github.com/gcc-mirror/gcc/ --shallow-since="2023-01-01"
fi

git -C gcc fetch -a
