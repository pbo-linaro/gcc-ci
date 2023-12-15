#!/usr/bin/env bash

set -euo pipefail

podman build --build-arg revision=$1 - < Dockerfile
