# disable all implicit make rules:
.SUFFIXES:

# wehere am i 
BASEDIR=$(shell  pwd)/../..

include $(BASEDIR)/Makefile.rules


############## build number #######################
#BUILDDATE= $(shell date --iso=seconds)

# http://www.linuxjournal.com/content/add-auto-incrementing-build-number-your-build-process
BUILD_NUMBER_FILE=build-number.txt


OBJECTS=cmd.o shell.o fdisk.o
#sd.o sdcard.o crc.o

OUTFILE=test
LOADADDR=1024

#OC=m68k-elf-objcopy
OC=m68k-uclinux-objcopy  
#OD=m68k-elf-objdump 
OD=m68k-uclinux-objdump 
	


#all: $(OBJECTS)	
#	$(LD)  $(OUTFILE).elf $(CLIBPATH)/startup.o $(OBJECTS) -static --whole-archive -l$(CLIB) > $(OUTFILE).map; \
#	#elf2bin -s -v -l $(LOADADDR) -o $(OUTFILE).68k $(OUTFILE).elf; \
#	$(OC) -I elf32-m68k -O binary -Sgv --adjust-start $(LOADADDR) $(OUTFILE).elf $(OUTFILE).68k; \
#	$(OD) -D -b binary -m m68k $(OUTFILE).68k > $(OUTFILE).dis

all: $(OBJECTS) $(BUILD_NUMBER_FILE)
	$(LD) $(BUILD_NUMBER_LDFLAGS)  $(LDFLAGS)  -o $(OUTFILE).elf $(OBJECTS) > $(OUTFILE).map;	
	$(BASEDIR)/tools/elf2bin -r -s -l $(LOADADDR) -o $(OUTFILE).68k $(OUTFILE).elf; \
	#$(OC) -I elf32-m68k -Sgv --adjust-start $(LOADADDR) $(OUTFILE).elf $(OUTFILE).68k; \
	$(OD) -D -b binary -m m68k $(OUTFILE).68k > $(OUTFILE).dis;\
	cp $(OUTFILE).68k NKC68K.ROM

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
	rm -f *.ROM
