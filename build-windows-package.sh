#!/bin/sh

# This is how the Windows package for release are built.

# Any existing TECkit-<version> folder TECkit-<version>.zip will be deleted.

# metadata
version=$(git describe)
foldername=TECkit-$version
filename=${foldername}.zip

# remove old folder and zip file
rm -rf $filename $foldername

# create folder for distribution
cp -a teckit-windows-bin $foldername
cd $foldername

# add files to folder

# runtime
cp -p /usr/lib/gcc/i686-w64-mingw32/5.3-posix/libgcc_s_sjlj-1.dll .
cp -p /usr/lib/gcc/i686-w64-mingw32/5.3-posix/libstdc++-6.dll .
cp -p /usr/i686-w64-mingw32/lib/libwinpthread-1.dll .

# old files
archive=../../teckit-archive/2.5.1/TECkit_2008-04-04
cp -p $archive/Samples.zip .
cp -p $archive/DropTEC.exe .
cp -p "$archive/TECkit Mapping Editor.exe" .

# documentation
unix2dos -n ../README README.txt
mkdir Documentation
cp -p ../docs/TECkit_Language.pdf Documentation
cp -p ../docs/TECkit_Tools.pdf Documentation
mkdir Developers
cp -p ../docs/Calling_TECkit_from_VB.doc "Developers/Calling TECkit from VB.doc"
cp -p ../docs/TECkit_Binary_Format.pdf Developers

# code
mkdir Developers/Public-headers
cp -p ../source/Public-headers/*.h Developers/Public-headers
cp -a ../source/Sample-tools Developers

# create zip file from folder
cd ..
zip -r $filename $foldername
