#!/bin/bash
echo "*** Recreating libtool files"
if [ "$LIBTOOLIZE" = "" ] && [ "`uname`" == "Darwin" ]; then
        if command -v "glibtoolize" > /dev/null; then
            LIBTOOLIZE=glibtoolize
        elif command -v "libtoolize" > /dev/null; then
            LIBTOOLIZE=libtoolize
        else
            echo "DIST: line $LINENO: command libtoolize or glibtoolize not found"
            exit 1
        fi
fi

if test -z $LTIZE; then
LTIZE="$AUTODIR""$LIBTOOLIZE"
fi
echo "$LTIZE"
	$LTIZE -f -c;

echo "*** Recreating aclocal.m4"
ACLOCAL="$AUTODIR""aclocal"
echo "$ACLOCAL"
	$ACLOCAL -I .;

echo "*** Recreating configure"
AUTOCONF="$AUTODIR""autoconf"
AUTOHEAD="$AUTODIR""autoheader"
	$AUTOHEAD ;
	$AUTOCONF;
	
echo "*** Recreating the Makefile.in files"
AUTOMAKE="$AUTODIR""automake"
	$AUTOMAKE --foreign -a -c;

