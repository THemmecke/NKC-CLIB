srcdir = .
prefix = /opt/m68k-elf-tools
exec_prefix = ${prefix}

bindir = ${exec_prefix}/bin
libdir = ${exec_prefix}/lib
includedir = ${prefix}/include

CC = gcc
CPU = m68k
TARGET = m68k-elf
CFLAGS = -g -O2
INCLUDES = 
CPPFLAGS = 
LDFLAGS =  -static
LIBS = 
INSTALL = /usr/bin/install -c

CCFLAGS = $(CFLAGS) $(DEFS) $(INCLUDES)

target_bindir = $(prefix)/$(TARGET)/bin
target_libdir = $(prefix)/$(TARGET)/lib

PROGS = flt2bin elf2bin

all: $(PROGS)
#	for prog in $(PROGS); do \
#		cp ./$$prog /opt/m68k-elf-tools/bin; \
#	done

flt2bin: $(srcdir)/flt2bin.c
	$(CC) $(CCFLAGS) $(LDFLAGS) -o $@ $(srcdir)/flt2bin.c $(LIBS)

elf2bin: $(srcdir)/elf2bin.c
	$(CC) $(CCFLAGS) $(LDFLAGS) -o $@ $(srcdir)/elf2bin.c $(LIBS)
clean:
	-rm -f $(PROGS) *.[oa]
#	for prog in $(PROGS); do \
#		rm /opt/m68k-elf-tools/bin/$$prog; \
#	done

