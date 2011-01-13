#!/bin/sh

# This is how the Windows binaries for release are built, so I don't forget!

# Any existing windows-build and teckit-windows-bin directories will be deleted.

PATH=/usr/local/mingw/bin:$PATH

rm -rf windows-build teckit-windows-bin

mkdir windows-build
cd windows-build

BUILD=$(../config.guess)

if which i586-mingw32msvc-gcc >/dev/null
then
	# Debian
	HOST=i586-mingw32msvc
else
	# Others, eg Mac, or built from source
	HOST=i386-mingw32
fi

../configure --build=$BUILD --host=$HOST --with-old-lib-names --without-system-zlib
make
make install-strip DESTDIR=`pwd`/inst
$HOST-strip --strip-unneeded inst/usr/local/lib/*.dll

cd ..
mkdir teckit-windows-bin
cp windows-build/inst/usr/local/bin/*.exe teckit-windows-bin
cp windows-build/inst/usr/local/lib/*.dll teckit-windows-bin

echo '###'
echo '### Built products:'
echo '###'
ls -l teckit-windows-bin
