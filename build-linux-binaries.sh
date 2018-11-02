#!/bin/sh
set -ev

rm -rf linux-build
mkdir linux-build
cd linux-build
../configure
make
(make check || cat test/dotests.pl.log)
sudo make install
cd ..
