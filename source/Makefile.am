teckitdir = $(top_srcdir)/source

zlibdir = $(top_srcdir)/zlib-1.2.3

if SYSTEM_ZLIB
ZLIB_CFLAGS = 
ZLIB_SOURCES =
else
ZLIB_CFLAGS = -I$(zlibdir)
ZLIB_SOURCES  = $(zlibdir)/adler32.c
ZLIB_SOURCES += $(zlibdir)/compress.c
ZLIB_SOURCES += $(zlibdir)/crc32.c
ZLIB_SOURCES += $(zlibdir)/deflate.c
ZLIB_SOURCES += $(zlibdir)/infback.c
ZLIB_SOURCES += $(zlibdir)/inffast.c
ZLIB_SOURCES += $(zlibdir)/inflate.c
ZLIB_SOURCES += $(zlibdir)/inftrees.c
ZLIB_SOURCES += $(zlibdir)/trees.c
ZLIB_SOURCES += $(zlibdir)/uncompr.c
ZLIB_SOURCES += $(zlibdir)/zutil.c
endif

AM_CPPFLAGS  += $(ZLIB_CFLAGS)
AM_CFLAGS    = $(AM_CPPFLAGS)

libTECkit_Compiler_la_SOURCES = $(teckitdir)/Compiler.cpp $(ZLIB_SOURCES)
libTECkit_Compiler_la_SOURCES += $(teckitdir)/UnicodeNames.cpp

libTECkit_la_SOURCES = $(teckitdir)/Engine.cpp $(ZLIB_SOURCES)

noinst_HEADERS = $(teckitdir)/Compiler.h
noinst_HEADERS += $(teckitdir)/Engine.h
noinst_HEADERS += $(teckitdir)/ulong_chartraits.h
noinst_HEADERS += $(teckitdir)/TECkit_Format.h

EXTRA_DIST = $(teckitdir)/NormalizationData.c

include $(top_srcdir)/source/Public-headers/Makefile.am
