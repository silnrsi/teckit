# simple makefile for TECkit tools under Unix-like system....

compiler_hdr = source/Compiler.h
compiler_src = source/Compiler.cpp source/UnicodeNames.cpp
compiler_obj = obj/Compiler.o obj/UnicodeNames.o

engine_hdr = source/Engine.h
engine_src = source/Engine.cpp source/NormalizationData.c
engine_obj = obj/Engine.o

libs = -lz -lstdc++ -lgcc -lc

CFLAGS = -I./source/Public-headers

all: libs tools

install: all
	cp lib/* /usr/local/lib/
	cp teckit_compile txtconv /usr/local/bin/

clean:
	rm -f obj/* lib/* teckit_compile txtconv

tools: teckit_compile txtconv

libs: compiler engine

compiler: $(compiler_obj)
	libtool -dynamic -o lib/TECkit_Compiler.dylib $(compiler_obj) $(libs)

engine: $(engine_obj)
	libtool -dynamic -o lib/TECkit.dylib $(engine_obj) $(libs)

teckit_compile: source/Sample-tools/TECkit_Compile.c lib/TECkit_Compiler.dylib
	$(CC) $(CFLAGS) -o $@ $< lib/TECkit_Compiler.dylib $(libs)

txtconv: source/Sample-tools/TxtConv.c lib/TECkit.dylib
	$(CC) $(CFLAGS) -o $@ $< lib/TECkit.dylib $(libs)

obj/%.o: source/%.cpp
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<
