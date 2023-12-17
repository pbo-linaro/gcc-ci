#!/usr/bin/env bash

set -euo pipefail

die()
{
    echo "$@" >&2
    exit 1
}

[ $# -eq 1 ] || die "usage: how_many_builds"
how_many_builds=$1; shift

# clone/update gcc src
if [ ! -d gcc ]; then
    git clone https://github.com/gcc-mirror/gcc/ --shallow-since="2023-01-01"
fi
git -C gcc fetch -a

workflow_file=.github/workflows/build_gcc.yml
oldest_rev=$(cat ${workflow_file} | grep oldest | sed -e 's/.*\[//' -e 's/\]//')
[ "$oldest_rev" != "" ] || die "can't find oldest revision to build"

get_all_revisions_to_build()
{
    git -C gcc log --reverse --oneline --format=format:%H ${oldest_rev}~1..origin/master
}

build_list="master"
num_to_build=1
for rev in $(get_all_revisions_to_build); do
    if [ $num_to_build -ge $how_many_builds ]; then
        break;
    fi

    echo "check if revision $rev was built"

    # can't use podman manifest inspect, as it fails with multi layer images
    need_build=0
    # no manifest == need to build
    docker manifest inspect docker.io/pbolinaro/gcc-ci:$rev > /dev/null || need_build=1
    if [ $need_build == 1 ]; then
        build_list="$build_list, $rev"
        num_to_build=$((num_to_build+1))
    elif [ $num_to_build == 1 ]; then
        oldest_rev=$rev
    fi
done

echo "new oldest_revision: $oldest_rev"
echo "build_list: $build_list"
sed -e "s/oldest:.*/oldest: [$oldest_rev]/" \
    -e "s/revision:.*/revision: [$build_list]/" \
    -i $workflow_file
