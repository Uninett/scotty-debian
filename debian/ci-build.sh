#!/bin/sh -e
#
# Runs *inside* the build container (see dev.sh). Builds the tcl-tnm package
# with gbp, which generates the orig tarball from the upstream/* tag recorded
# in debian/gbp.conf. If run as root, it also installs and smoke-tests the
# result.
#
cd /work

# tcl-tnm is Architecture: any, so every target suite needs its own build and
# its own output directory.
OUT="build/${SUITE_TAG:-debian-trixie}"

# AS_ROOT=1 runs as root against a bind-mounted tree, which would leave
# root-owned artifacts the invoking user cannot overwrite, breaking every
# later non-root build. Hand them back on the way out, however we exit.
if [ "$(id -u)" = 0 ] && [ -n "${HOST_UID:-}" ]; then
    trap 'chown -R "$HOST_UID:${HOST_GID:-$HOST_UID}" build 2>/dev/null || true' EXIT
fi

# gbp refuses to build from a tree with uncommitted changes unless told not to
# care; during development we usually do not care.
gbp buildpackage --git-ignore-new --git-export-dir="$OUT" \
    --git-builder="debuild --no-lintian -i -I -us -uc"

echo "=== lintian (informational) ==="
lintian -I "$OUT"/*.deb || true

echo "=== built packages ==="
ls -1 "$OUT"/*.deb

if [ "$(id -u)" = 0 ]; then
    echo "=== smoke test: install + load the extension ==="
    apt-get update
    apt-get install -y "$PWD/$OUT"/tcl-tnm_*.deb
    echo 'puts "Tnm [package require Tnm] loaded from [info library]"' | tclsh
    echo "SMOKE OK: package require Tnm succeeded"
else
    echo "(re-run via ./debian/smoke.sh to also install the .deb and test it)"
fi
