C-Lib structure (ANSI):
-----------------------

the following subdirs acomplish the ANSI standard C-lib:

 include	- all the libs include files
 
 alloc		- memory allocation functions	 
 ctype		- character type functions, tolower,toupper, isdigit etc.
 data		- implements atof, atoi etc.  
 io 		- file operations
 math		- standard clib math functions
 procont	- system internals: signal, abort, setjmp etc.
 sort		- qsort, bsearch
 string		- string functions and memory fill-,move-functions
 time		- time and RTC functions
 
 complib	- compiler (GCC) dependend math functions, fpgnulib,libgcc2 etc.
 

 startup	- program startup code for 68000 and 68020 NKC, initializes STACK, HEAP and buffers, handles the command line and relocation information
 nkc		- nkc specific code to handle memory management, defines nkc address space and JADOS/GP traps
 
 doc		- some documentation
 fdlibm		- a floating point emulation library (can be dis-/enabled in Makefile.rules) for system lacking a FPU
 
 drivers	- hardware driver subsystem
		- drivers/drivers.c is the abstraction layer which registeres the hardware drivers and in turn initializes the hardware
		- the abstraction layer uses char- and block devices. char devices are yet not implemented		
 fs		- filesystem implementation (NKC/JADOS-FS and FAT/FAT16/FAT32)
		- fs/fs.c is the abstraction layer which calls the registered driver
		- fs/fat and fs/nkc contain the file system implementations
		- fs/fat/fs_fat.c -> fatfs_init_fs initializes and registers the FAT filesystem
		- fs/nkc/fs_nkc.c -> nkcfs_init_fs initializes and registers the NKC filesystem (access to hardware is yed done via calls to JADOS/GP, so no hardware driver is used)
		- every new filesystem has to implement a 'struct file_operations' that can be registered to (and used by) the fs
		
 object		- holds all the compiled object files, which are bundled to lib/libCC.a and (if used) to libftlibm.a in lib
 lib		- the library files and the linker script ram.ld which defines the memory structure of the target system
 
 projects	- some sample project (in development) which show how to use the lib and makefiles
 
 
 tools		- contains two little apps elf2bin and flt2bin. elf2bin is used to generate a *.68K binary with relocation information from the ELF file that is produced by the GCC compiler
 
 Makefile	- Global Makefile which cycles through the subdir's Makefiles
 Makefile.rules - defines the rules for generating libCC (see inline documentation)

 
 Used tool-chain: 
  - m68k-uclinux (gcc version 4.5.1)
  - 