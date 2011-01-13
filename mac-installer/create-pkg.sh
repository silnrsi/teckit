#!/bin/sh

sudo rm -rf ./Archive

mkdir -p ./Archive/usr/local
cp -pRf ../teckit-mac/* ./Archive/usr/local

mkdir -p ./Archive/usr/local/include
cp -pRf ../source/Public-headers/*.h ./Archive/usr/local/include

mkdir -p ./Archive/Documents/TECkit
cp -pRf ../docs/*.pdf ./Archive/Documents/TECkit
cp -pRf ../license ./Archive/Documents/TECkit

sudo chown -R root:wheel ./Archive/usr
sudo chown -R root:admin ./Archive/Documents

/Developer/usr/bin/packagemaker	\
	-build						\
	-p "TECkit 2.5.3.pkg"		\
	-f ./Archive/				\
	-ds							\
	-r ./Resources/				\
	-i ./Info.plist				\
	-d ./Description.plist

rm -f TECkit.dmg
hdiutil create -srcfolder "TECkit 2.5.3.pkg" TECkit.dmg
hdiutil internet-enable TECkit.dmg
