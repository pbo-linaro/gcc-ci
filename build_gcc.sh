#!/usr/bin/env bash

set -euo pipefail

die()
{
    echo "$@" 1>&2
    exit 1
}

[ $# -eq 2 ] || die "usage: revision image_tag"

revision=$1;shift
image_tag=$1;shift
podman build --build-arg revision=$revision -t $image_tag - < Dockerfile
