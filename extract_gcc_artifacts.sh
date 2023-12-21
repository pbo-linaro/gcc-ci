#!/usr/bin/env bash

set -euo pipefail

die()
{
    echo "$@" 1>&2
    exit 1
}

[ $# -eq 2 ] || die "usage: image out_tar_gz"

image=$1;shift
out_tar_gz=$(readlink -f $1);shift

# strip gcc binaries (source code is not available anyway), and create a .tar.gz.
podman run -it -v /:/host $image bash -c \
"find /gcc-bin | xargs strip; cd / && tar czvf /host/$out_tar_gz gcc-bin"
echo "gcc toolchain available in $out_tar_gz"
