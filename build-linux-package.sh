#!/bin/sh

# This is how a Linux package is built

# Source and binary packages will be created in teckit-linux/teckit_$VERSION*
# together with a .changes file tying them together

rm -rf teckit-linux

mkdir -p teckit-linux/teckit

cd teckit-linux
../configure
make dist

cd teckit
mv ../teckit-*.tar.gz .
cp -a ../../debian-src debian

debuild
