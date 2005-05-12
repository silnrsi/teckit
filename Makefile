# simple makefile for TECkit tools under Unix-like system....

compiler_hdr = source/Compiler.h
compiler_src = source/Compiler.cpp source/UnicodeNames.cpp
compiler_obj = obj/Compiler.o obj/UnicodeNames.o

compiler = lib/TECkit_Compiler.dylib

engine_hdr = source/Engine.h
engine_src = source/Engine.cpp source/NormalizationData.c
engine_obj = obj/Engine.o

engine = lib/TECkit.dylib

# Tiger: some Mac OS X-specific stuff here for now... yuck... *FIXME*
libs = -lz -lstdc++ -lc -lgcc_s -lSystemStubs
libdir = -L/usr/lib/gcc/powerpc-apple-darwin8/4.0.0/ # won't exist on other systems

libs = -lz -lstdc++ -lc -lgcc

CFLAGS = -I./source/Public-headers

all: libs tools

install: all
	cp lib/* /usr/local/lib/
	cp teckit_compile txtconv /usr/local/bin/

clean:
	rm -f obj/* lib/* teckit_compile txtconv

tools: teckit_compile txtconv

libs: $(compiler) $(engine)

$(compiler): $(compiler_obj)
	libtool -dynamic -o lib/TECkit_Compiler.dylib $(compiler_obj) $(libs) $(libdir)

$(engine): $(engine_obj)
	libtool -dynamic -o lib/TECkit.dylib $(engine_obj) $(libs) $(libdir)

teckit_compile: source/Sample-tools/TECkit_Compile.c lib/TECkit_Compiler.dylib
	$(CC) $(CFLAGS) -o $@ $< $(compiler) $(libs)

txtconv: source/Sample-tools/TxtConv.c lib/TECkit.dylib
	$(CC) $(CFLAGS) -o $@ $< $(engine) $(libs)

obj/%.o: source/%.cpp
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<
