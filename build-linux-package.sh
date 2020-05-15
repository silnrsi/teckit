#!/bin/sh
set -ev

# This is how a Linux package is built

# Source and binary packages will be created in teckit-linux/teckit_$VERSION*
# together with a .changes file tying them together

rm -rf teckit-linux

mkdir -p teckit-linux/teckit

# make tarball
cd teckit-linux
../configure
make dist

# provide download verification
sha256sum teckit-*.tar.gz > SHA256SUMS
# gpg --armor --detach-sign teckit-*.tar.gz
# gpg --armor --detach-sign SHA256SUMS

# build Debian package
cd teckit
cp -p ../teckit-*.tar.gz .
cp -a ../../debian-src debian

debuild "$@"
