# disable all implicit make rules:
.SUFFIXES:

# wehere am i 
BASEDIR=$(shell  pwd)/../..

include $(BASEDIR)/Makefile.rules

# ######### seperate text and data (includes -fPIC/-fpic) #####################
# not supported with elf2bin (Feb. 2014) - need to relocate <R_68K_GOT32O> entries
# => error unsupported relocation (R_68K_PLT32)
#CCFLAGS += -msep-data

############## build number #######################
#BUILDDATE= $(shell date --iso=seconds)

# http://www.linuxjournal.com/content/add-auto-incrementing-build-number-your-build-process
BUILD_NUMBER_FILE=build-number.txt


LLD = m68k-uclinux-ld -M -T ram.ld -r --cref -o
LOC = m68k-uclinux-objcopy -O binary


#OBJECTS=stage1.o stage2_S.o stage2_c.o
#sd.o sdcard.o crc.o

OUTFILE=stage2
LOADADDR=1024

#OC=m68k-elf-objcopy
OC=m68k-uclinux-objcopy  
#OD=m68k-elf-objdump 
OD=m68k-uclinux-objdump 
	

#all: $(OBJECTS) $(BUILD_NUMBER_FILE)
#	$(LD) $(BUILD_NUMBER_LDFLAGS)  $(LDFLAGS)  -o $(OUTFILE).elf $(OBJECTS) > $(OUTFILE).map;	
#	$(BASEDIR)/tools/elf2bin -r -s -l $(LOADADDR) -o $(OUTFILE).68k $(OUTFILE).elf; \
#	#$(OC) -I elf32-m68k -Sgv --adjust-start $(LOADADDR) $(OUTFILE).elf $(OUTFILE).68k; \
#	#$(OD) -D -b binary -m m68k $(OUTFILE).68k > $(OUTFILE).dis;\
#	#cp $(OUTFILE).68k NKC68K.ROM

all:
	$(MAKE) stage1
	$(MAKE) stage2_c
	$(MAKE) stage2_S

stage2_c: stage2_c.o $(BUILD_NUMBER_FILE)
	$(LD) $(BUILD_NUMBER_LDFLAGS)  $(LDFLAGS)  -o $(OUTFILE).elf stage2_c.o > $(OUTFILE).map;	
	$(BASEDIR)/tools/elf2bin -r -s -l $(LOADADDR) -o $(OUTFILE).68k $(OUTFILE).elf; \

stage2_S: stage2_S.o
	$(LLD) stage2_S.elf stage2_S.o > stage2_S.map; \
	$(BASEDIR)/tools/elf2bin -s -l $(LOADADDR) -o stage2_S.68k stage2_S.elf; \
	$(OD) -D -b binary -m m68k stage2_S.68k > stage2_S.dis

stage1: stage1.o
	$(LLD) stage1.elf stage1.o > stage1.map; \
	$(BASEDIR)/tools/elf2bin -s -l $(LOADADDR) -o stage1.68k stage1.elf; \
	$(OD) -D -b binary -m m68k stage1.68k > stage1.dis



# Include build number rules.
include buildnumber.mak	

# define a pattern rule to compile all *.c files to *.o files:
%.o: %.c
#       $< = xxx.o, $@ = xxx.c, $* = xxx
	$(CC) $(INCLUDE) -v $(CCFLAGS) $(AFLAGS) -c $< > $*.lst

# define a pattern rule to compile all *.S files to *.o files:
%.o: %.S
#       $< = xxx.o, $@ = xxx.c, $* = xxx
	$(CC) $(CCFLAGS) $(AFLAGS) -c $< -o $@ > $*.lst
	

		


clean:
	rm -f *.o; \
	rm -f *.lst; \
	rm -f *.68k; \
	rm -f *.map; \
	rm -f *.elf; \
	rm -f *.flt; \
	rm -f *.dis; \
	rm -f *.ROM
