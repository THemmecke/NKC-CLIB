# disable all implicit make rules:
.SUFFIXES:

# wehere am i 
BASEDIR=$(shell  pwd)/../..

include $(BASEDIR)/Makefile.rules


LD = m68k-uclinux-ld -M -T ram.ld -r --cref -o
OC = m68k-uclinux-objcopy -O binary

OBJECTS=move20.o
TARGETS=move20
LOADADDR=0

#OC=m68k-elf-objcopy
OC=m68k-uclinux-objcopy  
#OD=m68k-elf-objdump 
OD=m68k-uclinux-objdump 
	
all: $(TARGETS)

move20: move20.o
	$(LD) move20.elf move20.o > move20.map; \
	$(BASEDIR)/tools/elf2bin -s -l $(LOADADDR) -o move20.68k move20.elf; \
	$(OD) -D -b binary -m m68k move20.68k > move20.dis; \
	cat move20.68k gp.bin > gp_.bin
	

# define a pattern rule to compile all *.c files to *.o files:
%.o: %.c
#       $< = xxx.o, $@ = xxx.c, $* = xxx
	$(CC) $(INCLUDE) -v $(CCFLAGS) $(AFLAGS) -c $< > $*.lst

# define a pattern rule to compile all *.S files to *.o files:
%.o: %.S
#       $< = xxx.o, $@ = xxx.c, $* = xxx
	$(CC) $(CCFLAGS) $(AFLAGS) -c $< -o $@ > $*.lst


.PHONY: clean


clean:
	rm -f *.o; \
	rm -f *.lst; \
	rm -f *.68k; \
	rm -f *.map; \
	rm -f *.elf; \
	rm -f *.flt; \
	rm -f *.dis
