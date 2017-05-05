#!/bin/sh

rm -rf build
mkdir build
cd build
../configure
make
sudo make install
sudo ldconfig
cd ..
