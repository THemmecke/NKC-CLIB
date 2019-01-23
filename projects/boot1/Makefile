# disable all implicit make rules:
.SUFFIXES:

# wehere am i 
BASEDIR=$(shell  pwd)/../..

include $(BASEDIR)/Makefile.rules


LLD = m68k-uclinux-ld -M -T ram.ld -r --cref -o
LOC = m68k-uclinux-objcopy -O binary


TARGETS=mbr 

OBJECTS=mbr.o
OUTFILE=mbr.bin

LOADADDR=0


all: $(TARGETS)
	
mbr: mbr.o
	$(LLD) mbr.elf mbr.o > mbr.map; \
	$(BASEDIR)/tools/elf2bin -s -l $(LOADADDR) -o mbr.68k mbr.elf; \
	$(OD) -D -b binary -m m68k mbr.68k > mbr.dis
	
	
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
	rm -f *.bin;\
	rm -f *.dis
