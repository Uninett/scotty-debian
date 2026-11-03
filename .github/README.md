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

Normally you do not install this directly: `apt install ritz` pulls it in. See
[zino-apt](https://github.com/Uninett/zino-apt) for the apt source, or
[Releases](../../releases) for loose `.deb`s.

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
