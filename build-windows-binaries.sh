#!/bin/sh

# This is how the Windows binaries for release are built, so I don't forget!

# Any existing windows-build and teckit-windows-bin directories will be deleted.

PATH=/usr/local/mingw/bin:$PATH

rm -rf windows-build teckit-windows-bin

mkdir windows-build
cd windows-build

BUILD=$(../config.guess)

# set $HOST
. ../build-windows-common
find_compiler

../configure --build=$BUILD --host=$HOST --with-old-lib-names --without-system-zlib --enable-final --disable-dependency-tracking
make
make install-strip DESTDIR=`pwd`/inst

if which $HOST-strip >/dev/null
then
	$HOST-strip --strip-unneeded inst/usr/local/lib/*.dll
fi

cd ..
mkdir teckit-windows-bin
cp windows-build/inst/usr/local/bin/*.exe teckit-windows-bin
cp windows-build/inst/usr/local/lib/*.dll teckit-windows-bin

# groff -k -mandoc -Tpdf docs/sfconv.1 > sfconv.pdf

echo '###'
echo '### Built products:'
echo '###'
ls -l teckit-windows-bin
