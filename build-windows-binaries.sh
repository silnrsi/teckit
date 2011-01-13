#!/bin/sh

# This is how the Windows binaries for release are built, so I don't forget!

# Any existing windows-build and teckit-windows-bin directories will be deleted.

PATH=/usr/local/mingw/bin:$PATH

rm -rf windows-build teckit-windows-bin

mkdir windows-build
cd windows-build

BUILD=$(../config.guess)

# Check the various names used for mingw
for HOST in mingw32 i586-mingw32msvc i386-mingw32
do
	if which $HOST-gcc >/dev/null
	then
		break
	fi
done

if [ -z "$HOST" ]
then
	echo "Could not find mingw. Please install it!" >&2
	exit 1
fi

../configure --build=$BUILD --host=$HOST --with-old-lib-names --without-system-zlib
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

echo '###'
echo '### Built products:'
echo '###'
ls -l teckit-windows-bin
