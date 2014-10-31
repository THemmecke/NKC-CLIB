/*
 * flt2bin.c: Convert FLAT binary format to binary (NKC-68k) format
 *
 * (c) 2009, Torsten Hemmecke <TorstenHemmecke@yahoo.de>
 * This is Free Software, under the BEER Public Licence 
 *
 *
 *     compile with: gcc -o flt2bin flt2bin.c
 */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "flat.h"


FILE *pflatfile=NULL;
FILE *pbinfile=NULL;

char *srcfile=NULL,*dstfile=NULL;

/*
struct bFLATHDR {
	char magic[4];			// 0x0000 should be "bFLAT"
	unsigned long rev;		// 0x0004 version
	unsigned long entry;		// 0x0008 Offset of first executable instruction  (text_start)
	unsigned long data_start;	// 0x000C Offset of data segment
	unsigned long data_end;		// 0x0010 Offset of data end (data_end = bss_start is assumed
	unsigned long bss_end;		// 0x0014 Offset of bss end
	unsigned long stack_size;	// 0x0018 Size of stack in bytes
	unsigned long reloc_start;	// 0x001C Offset of relocation records
	unsigned long reloc_count;	// 0x0020 Number of relocation records
	unsigned long flags;		// 0x0024 
	unsigned long build_date;	// 0x0028
	unsigned long filler[5];	// 0x002C reserved, set to zero
					// 0x0040 start of code
} flathdr;
*/

struct flat_hdr flathdr;	// bFLT header
unsigned long *preloctable;	// pointer to relocation table
unsigned char *pprog;		// pointer to program code

unsigned long loadaddr;		// load address of code
	
#define START_OF_CODE 0x40

void printflathdr(struct flat_hdr *phdr);
void printrelocs(unsigned long *preltab, unsigned int n, unsigned char *pprog);
void print_code(unsigned char *pprog, unsigned int n);
unsigned long endian(unsigned long val);
void printversion(void);
void usage(void);
long int getflength(FILE*);
void CleanUp();
void do_relocs(unsigned long *preltab, unsigned char *pprog, unsigned int n);

typedef enum { NOOPT, OUTFILENAME, LOADADDRESS, RUNVERBOSE } PRG_OPTION;


int main(int argc, char **argv)  {

 // ---process command line---
 int count;
 PRG_OPTION option = NOOPT;
 size_t result;
 unsigned char verbose = 0;
 
 // clear pointer
 preloctable = NULL;
 pprog = NULL;
 pbinfile = NULL;
 pflatfile = NULL;
 
 loadaddr = 0x400;
 
 if(argc < 2) { usage(); exit(0);}
 
 for (count = 1; count<argc; count++) {
 
         if (!strcmp(argv[count], "-o")) {
                        option = OUTFILENAME;
			if (argc-count < 3) { usage(); exit(0); }
                        else {
                                count++;
				dstfile = argv[count];
				continue;
			}
                }

	if(!strcmp(argv[count], "-v")) {		
		verbose = 1;		
		continue;
	}

	if(!strcmp(argv[count], "-l")) {
		option = LOADADDRESS;
		if (argc-count < 3) { usage(); exit(0); }
                        else {
                                count++;
				loadaddr = atoi(argv[count]);
				continue;
			}		
	}
	
	if(!strcmp(argv[count], "--help")) {
		printversion();
		usage();
		exit(0);
	}
 }

 srcfile = argv[count-1];   // last argument should be source filename

 switch(option){
	case OUTFILENAME:  break;
	case LOADADDRESS:  break;
	case RUNVERBOSE:   break;
	case NOOPT:	dstfile = "bin.out";		
 } 


 printversion();
 
 
 // open input file
 pflatfile = fopen(srcfile,"rb");

 if(!pflatfile) { 
   printf("error opening inputfile !\n");
   CleanUp();
   return 1;
 }

 // read bFLT header
 result = fread(&flathdr,1,sizeof(flathdr),pflatfile);
 if(result != sizeof(flathdr))
 {
   printf(" error reading bFLT header (%d read)\n", result);   
   CleanUp(); 
   return 1;
 }
 
 
 // print bFLT header
 if(verbose) printflathdr(&flathdr);

 // read pprog .text/.data
 if(fseek(pflatfile,endian(flathdr.entry),SEEK_SET))
 {
   printf(" error reading input file (SEEK)\n", result);   
   CleanUp(); 
   return 1;
 }
 
 pprog = (unsigned char*)malloc(endian(flathdr.data_end) - endian(flathdr.entry));
 if(pprog == NULL)
 { 
   printf(" Memory allocation error !\n");
   CleanUp(); 
   return 1;
 }

 result = fread(pprog,1,endian(flathdr.data_end) - endian(flathdr.entry),pflatfile);
	
 if(result != (endian(flathdr.data_end) - endian(flathdr.entry)))
 {
   printf(" error reading .text/.data (%d read)\n", result);
   CleanUp();   
   return 1;
 }

 // read relocation table
 preloctable = (unsigned long*)malloc(endian(flathdr.reloc_count)*4);
 
 if( preloctable == NULL )
 {
   printf(" Memory allocation error !\n");
   CleanUp(); 
   return 1;
 }

 if(fseek(pflatfile,endian(flathdr.reloc_start),SEEK_SET))
 {
   printf(" error reading input file (SEEK)\n", result);   
   CleanUp(); 
   return 1;
 }
 
 result = fread(preloctable,1,endian(flathdr.reloc_count)*4,pflatfile);
 
 if(result != endian(flathdr.reloc_count)*4)
 {
   printf(" error reading relocation table (%d read)\n", result);
   CleanUp();  
   return 1;
 }
 
 if(verbose) printrelocs(preloctable, endian(flathdr.reloc_count),pprog);

 // print code without relocs
 // print_code(pprog, getflength(pflatfile) - endian(flathdr.reloc_count)*4 - endian(flathdr.entry));

 // do relocs
 do_relocs(preloctable, pprog, endian(flathdr.reloc_count));
 
 // print code with relocs
 if(verbose) print_code(pprog, endian(flathdr.data_end) - endian(flathdr.entry));
 
 
 // write output file
 pbinfile = fopen(dstfile,"wb"); 
 if(!pbinfile) { 
   printf("error opening outputfile !\n");
   CleanUp(); 
   return 1;
 }
 
 fwrite(pprog,1,endian(flathdr.data_end) - endian(flathdr.entry),pbinfile);

 CleanUp();

 return 0;
}

void CleanUp()
{
  if(preloctable)  	free(preloctable);
  if(pprog)		free(pprog);
  if(pbinfile)		close(pbinfile);
  if(pflatfile)		close(pflatfile);
}

void printversion(){
 printf("\n flt2bin version 1.0     (C) 2012 Torsten Hemmecke\n\n");
}
void usage()
{
        printf("\nUsage: flt2bin [<options>] filename\n\n");
        printf("<options>:\n");
        printf("   -o <outputfile>             set output filename\n");
        printf("   -l <load-address>           absolute address, where program will be loaded\n");
        printf("   -v                          run verbose\n");
}

void printflathdr(struct flat_hdr *phdr){
 
 unsigned long ltime = endian(phdr->build_date);

 printf(" Magic Number: %c%c%c%c\n",phdr->magic[0],phdr->magic[1],phdr->magic[2],phdr->magic[3]);
 printf(" Revision    : 0x%lx\n",endian(phdr->rev));
 printf(" Entry       : 0x%lx\n",endian(phdr->entry));
 printf(" Data Start  : 0x%lx\n",endian(phdr->data_start));
 printf(" Data End    : 0x%lx\n",endian(phdr->data_end));
 printf(" BSS Start   : 0x%lx\n",endian(phdr->data_end));
 printf(" BSS End     : 0x%lx\n",endian(phdr->bss_end));
 printf(" Stack Size  : 0x%lx\n",endian(phdr->stack_size));
 printf(" Reloc Start : 0x%lx\n",endian(phdr->reloc_start));
 printf(" Reloc Count : 0x%lx\n",endian(phdr->reloc_count));
 printf(" Flags       : ");
 
 switch (endian(phdr->flags))
 {
 	case FLAT_FLAG_RAM:    printf("load program entirely into RAM\n"); break;
	case FLAT_FLAG_GOTPIC: printf("program is PIC with GOT\n"); break;
	case FLAT_FLAG_GZIP:   printf("all but the header is compressed\n"); break;
	case FLAT_FLAG_GZDATA: printf("only data/relocs are compressed (for XIP)\n"); break;
	default: printf("0x%lx\n",endian(phdr->flags));
 }
 
 printf(" Build date  : %s\n",ctime(&ltime));

}

unsigned long endian(unsigned long val){

 return ((val & 0xFF000000) >> 24) + ((val & 0x00FF0000) >> 8) + ((val & 0x0000FF00) << 8) + ((val & 0x000000FF) << 24);

}

/*
	print relocation table
		preltab - pointer to relocatio table
		n       - number of relocations
*/
void printrelocs(unsigned long *preltab, unsigned int n, unsigned char *pprog)
{
	unsigned int i;
	unsigned long addend,value;
	
	printf(" Relocation table (load at 0x%08lx):\n\n",loadaddr);
	
	printf(" Entry\tOffset\t\tAddend\t\t\tValue\n");
	
	for(i=0; i<n; i++,preltab++)
	{
		
		addend = *(pprog+endian(*preltab))   << 24;
		addend+= *(pprog+endian(*preltab)+1) << 16;
		addend+= *(pprog+endian(*preltab)+2) << 8;
		addend+= *(pprog+endian(*preltab)+3);
		
		value = addend + loadaddr;
		
		printf(" %d\t0x%08lx\t0x%08lx\t\t0x%08lx\n",i+1,(unsigned long)endian(*preltab),addend,value);
	}
	
	printf("\n\n");
}

void print_code(unsigned char *pprog, unsigned int n)
{
	unsigned int i,j=0;
	
	printf(" hexdump ( %d bytes code and data ):\n\n",n);
	printf("    0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F\n");
	
	for(i=0; (i*16)+j < n; i++)
	{	
		printf(" %x ",i);
		
		for(j=0; j<=15 && ((i*16)+j < n); j++)
		{
			printf("%02x ", *(pprog+(i*16)+j) );
		}
		printf("\n");
		j=0;
	}
	
	printf("\n\n");
}

void do_relocs(unsigned long *preltab, unsigned char *pprog, unsigned int n)
{
	unsigned int i;
	unsigned long offset,addend,value;
	
	for (i=0; i<n; i++, preltab++)
	{
		offset = endian(*preltab);
		
		addend = *(pprog+offset)   << 24;
		addend+= *(pprog+offset+1) << 16;
		addend+= *(pprog+offset+2) << 8;
		addend+= *(pprog+offset+3);
		
		value = addend + loadaddr; 
				
		*(pprog+offset)   = (unsigned char)((value & 0xFF000000) >> 24);
		*(pprog+offset+1) = (unsigned char)((value & 0x00FF0000) >> 16);
		*(pprog+offset+2) = (unsigned char)((value & 0x0000FF00) >> 8);
		*(pprog+offset+3) = (unsigned char)(value & 0x000000FF);
	}
}


long int getflength(FILE* pf)
{
 long save,length;

 if(pf == NULL) return 0;
 
 save = ftell(pf);
 fseek(pf,0,SEEK_END);
 length = ftell(pf);
 fseek(pf,save,SEEK_SET);
 
 return length;
}


