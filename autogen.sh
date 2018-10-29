#!/bin/sh

echo "*** Recreating libtool files"
if [ "$LIBTOOLIZE" = "" ] && [ "`uname`" = "Darwin" ]; then
        if command -v "glibtoolize" > /dev/null; then
            LIBTOOLIZE=glibtoolize
            $LIBTOOLIZE -f -c;
        elif command -v "libtoolize" > /dev/null; then
            LIBTOOLIZE=libtoolize
            $LIBTOOLIZE -f -c;
        else
            echo "DIST: line $LINENO: command libtoolize or glibtoolize not found"
            exit 1
        fi
fi

if [ "$LIBTOOLIZE" = "" ] && [ "`uname`" = "Linux" ]; then
        if command -v "libtoolize" > /dev/null; then
            LIBTOOLIZE=libtoolize
            $LIBTOOLIZE -f -c;
        else
            echo "DIST: line $LINENO: command libtoolize not found"
            exit 1
        fi
fi

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

