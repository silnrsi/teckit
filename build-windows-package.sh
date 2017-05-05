#!/bin/sh

# This is how the Windows package for release are built.

# Any existing TECkit-<version> folder and TECkit-<version>.zip will be deleted.

# metadata
VERSION="2.5.6"
foldername=TECkit-${VERSION}
filename=${foldername}.zip

# remove old folder and zip file
rm -rf $filename $foldername

# create folder for distribution
cp -a teckit-windows-bin $foldername
cd $foldername

# add files to folder

# runtime

# set $HOST
. ../build-windows-common
find_compiler

# The cross-compiler defaults to the Windows threading model
# which does not require the libwinpthread-1.dll runtime file.
# This file is needed if the POSIX threading model is specified.
# On an Ubuntu system see
# /usr/share/doc/g++-mingw-w64-i686/README.Debian
# or
# /usr/share/doc/gcc-mingw-w64-i686/README.Debian
# (might be the same contents) for more details.
# TECkit 2.5.4 and 2.5.6 on Windows did need this file,
# so presumably used the POSIX threading model.
for FILE in libgcc_s_sjlj-1.dll libstdc++-6.dll # libwinpthread-1.dll
do
    cp -p $($HOST-gcc -print-file-name=$FILE) .
done

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
