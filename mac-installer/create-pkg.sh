#!/bin/bash

# adjust this to newer version numbers
VERSION="2.5.13"
echo current version is: $VERSION

sudo rm -rf ./Pkg

mkdir -p ./Pkg/usr/local
cp -p -R ../teckit-mac/* ./Pkg/usr/local

mkdir -p ./Pkg/usr/local/include
cp -p -R ../source/Public-headers/*.h ./Pkg/usr/local/include

mkdir -p ./Img
cp -p -R ../docs/*.pdf ./Img
cp -p -R ../docs/*.odt ./Img
cp -p -R ../docs/*.doc ./Img

cp -p -R ../license ./Img

sudo chown -R root:wheel ./Pkg/usr
sudo chown -R $USER:staff ./Img
sudo chmod -R a+rw ./Img

/usr/bin/pkgbuild  --identifier "org.sil.scripts.teckit" --analyze --root Pkg/ components.plist

/usr/bin/pkgbuild --identifier "org.sil.scripts.teckit" --root Pkg/ --component-plist components.plist --version $VERSION Img/TECkit-$VERSION.pkg

/usr/bin/hdiutil create -verbose -volname "TECkit" -srcdir Img/ -ov TECkit-$VERSION.dmg
