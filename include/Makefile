# disable all implicit make rules:
.SUFFIXES:

# wehere am i 
BASEDIR=$(shell  pwd)/..

include $(BASEDIR)/Makefile.rules

# to prevent searching the standard include path:
export C_INCLUDE_PATH :=$(BASEDIR)/include
export CPLUS_INCLUDE_PATH :=$(BASEDIR)/include

# ############# use m68k-tools ######################

export PATH:=/opt/m68k-elf-tools/bin:$(PATH)
# von Hand Copy&Paste on cmdline: export PATH=/opt/m68k-elf-tools/bin:$PATH

CC=m68k-elf-gcc
AS=

# CCFLAGS:
# -0s                           Optimize for size (-O0 = do not Optimize, default)
# -g                            Add explicit .globl declarations
# -fomit-frame-pointer          Dont keep the frame-pointer in register for functions that don't need one.
# -D__KERNEL__  		these are probably macros in the source code (?)        
# -D__ASSEMBLY__

CCFLAGS =  -O3 -g -D__KERNEL__ -D__ASSEMBLY__
#CCFLAGS = -msep-data
#CCFLAGS = -Os -g -fomit-frame-pointer -D__KERNEL__ -D__ASSEMBLY__
#CCFLAGS = -D__ASSEMBLY__


# linker flags:
# -M 
# -T ram.ld  
# --cref  
# -c			no main function
# -o
# -r                    generate relocatable output (compile without -r to see undefined symbols)
# --warn-once
# --cref
LD = m68k-elf-ld -M -T ram.ld --cref  -o
#LD = m68k-elf-ld -M -T ram.ld -r --warn-once --cref  -o


# Assembler Flags:
AFLAGS = -pipe -DNO_MM -DNO_FPU -m68020 -Wa,-a,-ad,--bitwise-or

EF = m68k-elf-elf2flt -v -o

#EF = m68k-uclinux-elf2flt -o 
#LD = m67k-elf-ld -M -T ram.ld -r --cref -o

OC = m68k-elf-objcopy -O binary
OCTEXT = m68k-elf-objcopy -O binary -j .text
OCDATA = m68k-elf-objcopy -O binary -j .data


# ###################################################

LIBCSRC=$(BASEDIR)/lib/
INCLUDE=$(BASEDIR)/include
ARCH=$(BASEDIR)/arch/m68k


# ############### m68k-tools ###################################
 

OBJECTS= divs.o divu.o mods.o modu.o muls.o mulu.o stkchk.S

TARGET=hello

all: 	$(OBJECTS)
#	$(LD) $(TARGET).elf $(OBJECTS) > $(TARGET).map; \
#	$(EF) $(TARGET).flt $(TARGET).elf; \
#	flt2bin -o $(TARGET).68k $(TARGET).flt

#abort.o:
#	$(CC) $(INCLUDE) $(CCFLAGS) $(AFLAGS) -c abort.c > abort.lst
        
# define a pattern rule to compile all *.c files to *.o files:
%.o: %.c
#       $< = xxx.o, $@ = xxx.c, $* = xxx
	$(CC) $(INCLUDE) $(CCFLAGS) $(AFLAGS) -c $< > $*.lst


# define a pattern rule to compile all *.S files to *.o files:
%.o: %.S
#       $< = xxx.o, $@ = xxx.c, $* = xxx
	$(CC) $(CCFLAGS) $(AFLAGS) -c $< -o $@ > $*.lst

# ##############################################################
	

clean:
	rm -f *.s; \
	rm -f *.o; \
	rm -f *.lst; \
	rm -f *.elf; \
	rm -f *.68k; \
	rm -f *.flt; \
	rm -f *.map; \
	rm -f libc

