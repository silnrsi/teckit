#!/bin/sh

rm -rf ./Archive

mkdir -p ./Archive/usr/local
cp -pRf ../teckit-mac/* ./Archive/usr/local

mkdir -p ./Archive/usr/local/include
cp -pRf ../source/Public-headers/*.h ./Archive/usr/local/include

mkdir -p ./Archive/Documents/TECkit
cp -pRf ../docs/*.pdf ./Archive/Documents/TECkit
cp -pRf ../license ./Archive/Documents/TECkit

/Developer/Tools/packagemaker	\
	-build						\
	-p "TECkit 2.5.1.pkg"		\
	-f ./Archive/				\
	-ds							\
	-r ./Resources/				\
	-i ./Info.plist				\
	-d ./Description.plist

hdiutil create -srcfolder "TECkit 2.5.1.pkg" TECkit.dmg
hdiutil internet-enable TECkit.dmg
