# disable all implicit make rules:
.SUFFIXES:

# wehere am i 
BASEDIR=$(shell  pwd)/../..

include $(BASEDIR)/Makefile.rules


LLD = m68k-uclinux-ld -M -T ram.ld -r --cref -o
LOC = m68k-uclinux-objcopy -O binary


TARGETS=mbr ldr test hello

OBJECTS=test.o
OUTFILE=NKC68K.ROM

LOADADDR=0


all: $(TARGETS)
	
mbr: mbr.o
	$(LLD) mbr.elf mbr.o > mbr.map; \
	$(BASEDIR)/tools/elf2bin -s -l $(LOADADDR) -o mbr.68k mbr.elf; \
	$(OD) -D -b binary -m m68k mbr.68k > mbr.dis
	
ldr: ldr.o
	$(LLD) ldr.elf ldr.o > ldr.map; \
	$(BASEDIR)/tools/elf2bin -s -l $(LOADADDR) -o ldr.68k ldr.elf; \
	$(OD) -D -b binary -m m68k ldr.68k > ldr.dis
	
hello: hello.o
	$(LLD) hello.elf hello.o > hello.map; \
	$(BASEDIR)/tools/elf2bin -s -l $(LOADADDR) -o hello.68k hello.elf; \
	$(OD) -D -b binary -m m68k hello.68k > hello.dis	
	
test: test.o	
	$(LD)  $(LDFLAGS) -o $(OUTFILE).elf $(OBJECTS) > $(OUTFILE).map;	\
	$(BASEDIR)/tools/elf2bin -r -s -l $(LOADADDR) -o $(OUTFILE) $(OUTFILE).elf; \
	$(OC) -I elf32-m68k -S --adjust-start $(LOADADDR) $(OUTFILE).elf $(OUTFILE)_.68k; \
	$(OD) -D -b binary -m m68k $(OUTFILE) > $(OUTFILE).S; \
	$(OD) -D -b binary -m m68k $(OUTFILE)_.68k > $(OUTFILE)_.S;
	
# define a pattern rule to compile all *.c files to *.o files:
%.o: %.c
#       $< = xxx.o, $@ = xxx.c, $* = xxx
	$(CC) $(INCLUDE) -v $(CCFLAGS) $(AFLAGS) -c $< > $*.lst

# define a pattern rule to compile all *.S files to *.o files:
%.o: %.S
#       $< = xxx.o, $@ = xxx.c, $* = xxx
	$(CC) $(CCFLAGS) $(AFLAGS) -c $< -o $@ > $*.lst; \
	

.PHONY: clean


clean:
	rm -f *.o; \
	rm -f *.lst; \
	rm -f *.68k; \
	rm -f *.map; \
	rm -f *.elf; \
	rm -f *.flt; \
	rm -f *.ROM*;\
	rm -f *.dis
