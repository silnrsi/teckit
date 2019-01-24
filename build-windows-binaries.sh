#!/bin/sh
set -ev

# This is how the Windows binaries for release are built, so I don't forget!

# Any existing windows-build{32,64} and teckit-windows-bin directories will be deleted.

PATH=/usr/local/mingw/bin:$PATH
. ./build-windows-common

rm -rf $WINDOWS

file /usr/bin/i686-w64-mingw32-ld /usr/bin/x86_64-w64-mingw32-ld

for bit in 32 64
do
    WINDOWS_BUILD=windows-build${bit}
    WINDOWS_BIN=$WINDOWS/${bit}-bit
    rm -rf $WINDOWS_BUILD
    mkdir $WINDOWS_BUILD
    cd $WINDOWS_BUILD
    BUILD=$(../config.guess)
    set_compiler $bit

    echo "BUILD=${BUILD} HOST=${HOST} bit=${bit}"
    ../configure --build=$BUILD --host=$HOST --with-old-lib-names --without-system-zlib --enable-final --disable-dependency-tracking
    make
    make install-strip DESTDIR=`pwd`/inst

    if which $HOST-strip >/dev/null
    then
        $HOST-strip --strip-unneeded inst/usr/local/lib/*.dll
    fi
    cd ..

    mkdir -p $WINDOWS_BIN
    cp $WINDOWS_BUILD/inst/usr/local/bin/*.exe $WINDOWS_BIN
    cp $WINDOWS_BUILD/inst/usr/local/lib/*.dll $WINDOWS_BIN
done

cd docs
for manpage in *.1
do
    groff -k -mandoc -Tpdf $manpage > ../${WINDOWS}/${manpage}.pdf
done
cd ..

echo '###'
echo '### Built products:'
echo '###'
ls -l -R $WINDOWS
