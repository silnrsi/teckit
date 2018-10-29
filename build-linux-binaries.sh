#!/bin/sh

rm -rf linux-build
mkdir linux-build
cd linux-build
../configure
make
sudo make install
sudo ldconfig
cd ..
