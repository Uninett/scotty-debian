# scotty-debian

Debian and Ubuntu packaging for the **Tnm** Tcl extension, built from the
[FlightAware scotty fork](https://github.com/flightaware/scotty). The packaging
lives in [`debian/`](../debian) on the `debian/latest` branch.

```
source "scotty"  ->  binary "tcl-tnm"   (Architecture: any)
```

It exists because [Ritz](https://github.com/Uninett/ritz-debian) needs
`package require Tnm`, which historically came from Debian's `scotty` package.
That package was orphaned and removed from the archive years ago. Only the Tcl
extension is shipped; the `scotty`, `nmtrapd` and `nmicmpd` binaries are built
and then discarded.

Debian's Tcl policy names extension packages `tcl-<ext>`, hence `tcl-tnm`.

## Installing

Normally you do not install this directly; it is a dependency of
[ritz](https://github.com/Uninett/ritz-debian), and the
[ritz-debian README](https://github.com/Uninett/ritz-debian#installing) covers
installing the pair together.

To install it alone, download the `.deb` for your distribution from
[Releases](../../releases) and:

```sh
sudo apt install ./tcl-tnm_*.deb
```

Or fetch it without a browser, with `SUITE` set to `trixie` for Debian 13 or
`noble` for Ubuntu 24.04:

```sh
SUITE=trixie
curl -fsSL https://api.github.com/repos/Uninett/scotty-debian/releases/latest \
  | grep -o "https://[^\"]*\.${SUITE}1_[^\"]*\.deb" \
  | grep -v dbgsym \
  | xargs -r -n1 curl -fsSLOJ
sudo apt install ./tcl-tnm_*.deb
```

Built for amd64 only.

## Building it yourself

Needs Docker only:

```sh
./debian/build.sh                      # Debian trixie, into ./build/
SUITE=ubuntu:24.04 ./debian/build.sh   # another suite
./debian/smoke.sh                      # build, install, and check package require Tnm
```

`tcl-tnm` is `Architecture: any`, so every target suite needs its own build.

## Layout

A `gbp` fork of upstream: the packaging branch carries FlightAware's history
with `debian/` added on top, and `gbp buildpackage` exports the orig tarball
straight from upstream's own release tags (`upstream-tag = v%(version)s`).
