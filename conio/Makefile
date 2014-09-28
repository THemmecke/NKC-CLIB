

# disable all implicit make rules:
.SUFFIXES:

# wehere am i 
BASEDIR=$(shell  pwd)/..


include $(BASEDIR)/Makefile.rules


# ###################################################

LIBDIR=$(BASEDIR)/lib/
INCLUDE=$(BASEDIR)/include
LIBNAME=libconio

export PATH:=/opt/m68k-elf-tools/bin:$(PATH)

LIBOBJS = conio.o

OBJECTS = $(LIBOBJS)


# ------------------------------------------------------------------------------------

############### compiler flags ###########################
# verbose output
#CCFLAGS +=--verbose


############### assembler flags ###########################
AFLAGS = 
# ######### ##############
AFLAGS += -pipe 
# ######### preprocessor variable ##############
AFLAGS += -DM$(CPU) 
# ######### assembler switch: assemble for $(CPU) ##############
AFLAGS += -m$(CPU) 
# ### tell the compiler to use FPU commands or software floating point ###
ifeq ($(CONFIG_FPU),1)
AFLAGS += -m68881
else
AFLAGS += -msoft-float
endif

# -Wa,option instrucs the gnu c compiler to pass option to the assembler, so this is an assembler option given to the compiler
AFLAGS += -Wa,-a,-ad


#	$(LD) $(LDFLAGS) $(LIBOBJECTS) -o $(LIBDIR)/libCC.o; \
# create a static library	
all:	$(OBJECTS); \
	ar rcs $(LIBDIR)$(LIBNAME).a $(LIBOBJS)

	
# define a pattern rule to compile all *.c files to *.o files:
%.o: %.c
#       $< = xxx.o, $@ = xxx.c, $* = xxx
	$(CC) $(INCLUDE) $(CCFLAGS) $(AFLAGS) -c $< > $*.lst

# define a pattern rule to compile all *.S files to *.o files:
%.o: %.S
#       $< = xxx.o, $@ = xxx.c, $* = xxx
	$(CC) $(CCFLAGS) $(AFLAGS) -c $< -o $@ > $*.lst

# define a pattern rule to compile all *.asm files to *.o files:
%.o: %.asm
#       $< = xxx.o, $@ = xxx.c, $* = xxx
	$(CC) $(CCFLAGS) $(AFLAGS) -c $< -o $@ > $*.lst
	
clean:	
	rm -f *.o; \
	rm -f *.lst; \
	rm -f *.68k; \
	rm -f *.map; \
	rm -f .elf; \
	rm -f *.flt; \
	rm -f $(LIBDIR)$(LIBNAME).a
