#!/bin/sh -e
#
# Like build.sh, but runs as root inside the container so it can also install
# the freshly built .deb and check that "package require Tnm" works.
#
cd "$(dirname "$0")/.."
NONINTERACTIVE=1 AS_ROOT=1 ./debian/dev.sh ./debian/ci-build.sh
