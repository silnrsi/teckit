# This is how the Windows binaries for release are built, so I don't forget!

# Any existing windows-build and teckit-windows-bin directories will be deleted.

PATH=/usr/local/mingw/bin:$PATH

rm -rf windows-build teckit-windows-bin

mkdir windows-build
cd windows-build

../configure --build=i386-darwin --host=i386-mingw32 --with-old-lib-names
make
make install-strip DESTDIR=`pwd`/inst
i386-mingw32-strip --strip-unneeded inst/usr/local/lib/*.dll

cd ..
mkdir teckit-windows-bin
cp windows-build/inst/usr/local/bin/*.exe teckit-windows-bin
cp windows-build/inst/usr/local/lib/*.dll teckit-windows-bin

echo '###'
echo '### Built products:'
echo '###'
ls -l teckit-windows-bin
