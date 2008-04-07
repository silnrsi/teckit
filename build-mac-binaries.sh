# This is how the Mac binaries for release are built, so I don't forget!

# Any existing mac-build and teckit-mac/{bin,lib} directories will be deleted.

rm -rf mac-build teckit-mac-bin

mkdir mac-build
cd mac-build

# configure for building Universal binaries
../configure CFLAGS='-arch ppc -arch i386' CXXFLAGS='-arch ppc -arch i386' LDFLAGS='-arch ppc -arch i386' --disable-dependency-tracking
make
make install DESTDIR=`pwd`/inst

cd ..
mkdir -p teckit-mac/bin
mkdir -p teckit-mac/lib
cp -pRf mac-build/inst/usr/local/bin/* teckit-mac/bin
cp -pRf mac-build/inst/usr/local/lib/* teckit-mac/lib

echo '###'
echo '### Built products:'
echo '###'
ls -l teckit-mac/bin teckit-mac/lib
