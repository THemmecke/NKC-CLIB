/*
 * elf2bin.c: Convert ELF32 binary format to binary (NKC-68k) format
 *
 * (c) 2012, Torsten Hemmecke <TorstenHemmecke@yahoo.de>
 * This is Free Software, under the BEERWARE Copyright
 *
 *
 *     compile with: gcc -o elf2bin elf2bin.c
 */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

#include "elf.h"

const char versioninfo[] = "\n elf2bin version 1.0.171025    (C) 2012-2017 Torsten Hemmecke\n\n";

/* ------------- prototypes -------------- */

void printversion(void);
void usage(void);
void CleanUp();
long int getflength(FILE* pf);
void dump_data(unsigned char *pprog, unsigned int n);

unsigned long endian(unsigned long val);

static Elf32_Ehdr* get_elf32_header(void *address);

void do_relocations(Elf32_Ehdr* elf_hdr, unsigned long loadaddr);
void do_rela(Elf32_Ehdr* elf_hdr, unsigned int section, unsigned long reltype, unsigned long loadaddr);

void add_bss_reloc(unsigned long offset, unsigned long type, unsigned long value);

unsigned long get_section_offset_by_name(Elf32_Ehdr* elf_hdr, char* name);
unsigned long get_section_size_by_name(Elf32_Ehdr* elf_hdr, char* name);

void print_elf_hdr(Elf32_Ehdr* hdr);
void print_sec_hdrs(Elf32_Ehdr* elf_hdr);
void print_prg_hdrs(Elf32_Ehdr* elf_hdr);
void scan_sym_table(Elf32_Ehdr* elf_hdr);
void print_undef_comm_syms(Elf32_Ehdr* elf_hdr); // print list of unedfined or COMMON symbols
void print_nopics(Elf32_Ehdr* elf_hdr, unsigned int section, unsigned long reltype, unsigned long loadaddr);

void print_sym_table_d(Elf32_Ehdr* elf_hdr);
void print_str_table_d(Elf32_Ehdr* elf_hdr);
void print_reloc_table_d(Elf32_Ehdr* elf_hdr);

void debug_out(Elf32_Ehdr* hdr);

static const char *get_section_type_name (unsigned long sh_type);
static const char *get_elf_section_flags (unsigned long sh_flags);
static const char* elf_m68k_reloc_type(unsigned long type);
static const char* get_symbol_type(unsigned long type);
static const char* get_symbol_bind(unsigned long bind);
static const char* get_symbol_shndx(unsigned long indx);
static const char *get_symbol_visibility (unsigned int visibility);


/* ------------- variables and constants -------------- */

FILE *pelffile=NULL;	/* file handle for source and destinaton file */
FILE *pbinfile=NULL;


			
char *srcfile=NULL,*dstfile=NULL;	/* names of source and destination file */

unsigned char* pelf=NULL;		/* pointer to elf file in memory */
long int elf_size;			/* size of elf file in bytes     */

unsigned long loadaddr=0xFFFFFFFF;	/* target system load address of code, defaults to elf_hdr->e_entry */

unsigned char verbose = 0;							/* =1 if verbose operation */
unsigned char vverbose = 0;							/* =1 if vverbose operation (more verbose than verbose)*/
unsigned char addreloc = 0;
unsigned char strip = 0;							/* =1 if strip debugging information (i.e. .comment section, the .stab can be removed by gcc with option -g0)*/
unsigned char debug = 0;							/* =1 -> print out all tables in plain format */
unsigned long undefs = 0;							/* =1 if we found undefined symbols */
unsigned long commons = 0;							/* =1 if we found COMMON symbols */
unsigned long nopic = 0;							/* =1 if code is not position independend */

typedef enum { NOOPT, OUTFILENAME, LOADADDRESS, RUNVERBOSE } PRG_OPTION;


// relocation entry for binary target (written to bss segment)
struct _entry {
	unsigned long offset;
	unsigned long type;
	unsigned long value;
	struct _entry *pnext;
};

// single linked list
struct _entry *preloc_list = NULL;


int main(int argc, char **argv) 
{
 size_t result;


// ------- process command line ----------
 int count;
 PRG_OPTION option = NOOPT;
 
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
	
	if(!strcmp(argv[count], "-vv")) {		
		vverbose = 1;	
		verbose = 1;	
		continue;
	}
	
	if(!strcmp(argv[count], "-s")) {		
		strip = 1;		
		continue;
	}
	
	if(!strcmp(argv[count], "-r")) {		
		addreloc = 1;				
		continue;
	}
	
	if(!strcmp(argv[count], "-d")) {		
		debug = 1;		
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

 /* --------- start main ----------- */
 printversion();
 
 
 /* ------- open/read/close source file */
 pelffile = fopen(srcfile,"rb");

 if(!pelffile) { 
   printf("error opening inputfile !\n");
   CleanUp();
   return 1;
 }
 
 elf_size = getflength(pelffile);
 
 pelf = (unsigned char*)malloc(elf_size);
 if(pelf == NULL)
 { 
   printf(" Memory allocation error !\n");
   CleanUp(); 
   return 1;
 }
 
 result = fread(pelf,1,elf_size,pelffile);
	
 if(result != elf_size )
 {
   printf(" error reading elf file into memory (%d read)\n", result);
   CleanUp();   
   return 1;
 }
 
 if(pelffile) close(pelffile);
 
 
 /* ------------ process elf file ---------- */
 
 if(!get_elf32_header((void*)pelf))
 {
 	printf(" wrong file format !\n");
 	CleanUp();
 	exit(1);
 }
 
 
 if(debug) debug_out(get_elf32_header((void*)pelf));
 
 if(verbose) print_elf_hdr(get_elf32_header((void*)pelf));
 if(verbose) print_sec_hdrs(get_elf32_header((void*)pelf));
 if(verbose) print_prg_hdrs(get_elf32_header((void*)pelf));
 
 if(loadaddr==0xFFFFFFFF) loadaddr = endian(get_elf32_header((void*)pelf)->e_entry);
 
 do_relocations(get_elf32_header((void*)pelf),loadaddr);
 
 scan_sym_table(get_elf32_header((void*)pelf));
    
 unsigned char progsegs[255]; /* max 255 programmsegments */
 unsigned int i,j,n,pc,tmp;
 
 for(i=0; i<255; i++) progsegs[i] = 0;  /* initialize array, 0 is of type NULL - i.e. never a PROGSEG */
       
    
 Elf32_Ehdr *elf_hdr = get_elf32_header((void*)pelf);				/* pointer to elf header */


 unsigned long number = endian(((unsigned long)elf_hdr->e_shnum) << 16);		/* number of section headers      */
 unsigned long shoffset = endian(elf_hdr->e_shoff);				/* offset to section header table */
 Elf32_Shdr *psh = (Elf32_Shdr *) ((unsigned long)elf_hdr+shoffset);		/* points to start of section headers */


 Elf32_Shdr *pShStrTabHdr = (Elf32_Shdr *)((unsigned long)psh + endian(((unsigned long)elf_hdr->e_shstrndx) << 16)*sizeof(Elf32_Shdr));  
						/* pShStrTabHdr points to section header of .shstrtab */

 char* pShStrTab = (char*)((unsigned long)elf_hdr + endian(pShStrTabHdr->sh_offset)); /* pShStrTab points to section header string table */


 if (verbose & !vverbose) printf("\n prog sections: ");
 
 for(i=0,n=0;i<number; i++)
 {		

	if( endian(psh[i].sh_type) == SHT_PROGBITS )
	{		
		
		if(strip && !strstr(&pShStrTab[endian(psh[i].sh_name)],".text") && !strstr(&pShStrTab[endian(psh[i].sh_name)],".data")) {
			printf("\n stripping section [%d] '%s'...\n",i,&pShStrTab[endian(psh[i].sh_name)]);
			continue;
			}
	
	        
			
		progsegs[n]=i;
		n++;
		
		if(verbose & !vverbose)
		{
		  printf("[%d] ",i);
		}
								
		if(vverbose)
		{	
		  unsigned char* pProg = (unsigned char*)((unsigned long)elf_hdr + endian(psh[i].sh_offset));	/* pProg points to Prog */
		  printf(" dump of section \' %s \':\n",&pShStrTab[endian(psh[i].sh_name)]); 	
		  dump_data(pProg, endian(psh[i].sh_size));
		}
	}
	
 } 
 printf("\n");
	
	
 /* bubble sort sections: */
 
 
 for(i=1;  i<=n; i++)
   for(j=0; j<n-i; j++)
   	if( endian(psh[progsegs[j]].sh_addr) > endian(psh[progsegs[j+1]].sh_addr) )
   	{
   		tmp = progsegs[j];
   		progsegs[j] = progsegs[j+1];
   		progsegs[j+1] = tmp;
   	}
   		 
 
  /* ------- open/write/close binary file */
 pbinfile = fopen(dstfile,"wb");

 if(!pbinfile) { 
   printf("error opening outputfile %s !\n",dstfile);
   CleanUp();
   return 1;
 }
 
 /* ------ write segments to file with alignment ----- */
 
 unsigned char null = 0;
 unsigned char full = 0xFF;
 unsigned char NOP[] = {0x4e,0x71}; 
  	
 
 if(verbose) printf(" writing bin file (%s)...\n",dstfile);
 
 if(n>0) pc = endian(psh[progsegs[0]].sh_addr);	/* reset program counter to start of first segment*/
 
 for(i=0; i<n; i++)     	/* cycle all relevant sections */
 {
 				
 	if(verbose) printf(" Section [%d] ('%s'): ",progsegs[i],&pShStrTab[endian(psh[progsegs[i]].sh_name)]);
 	if(verbose) printf(" offset = 0x%08lx, start = 0x%08lx, size = 0x%08lx, ",endian(psh[progsegs[i]].sh_offset), endian(psh[progsegs[i]].sh_addr), endian(psh[progsegs[i]].sh_size));
 	
  	if(pc > endian(psh[progsegs[i]].sh_addr))	/* check if sections overlap */
  	{
  		printf(" sections '%s' and '%s' overlap (%ld bytes) !\n Missing definition in linker script ?\n",
  			&pShStrTab[endian(psh[progsegs[i-1]].sh_name)],&pShStrTab[endian(psh[progsegs[i]].sh_name)], pc - endian(psh[progsegs[i]].sh_addr));

  		CleanUp();
  		exit(1);
  	}
  

  	for(; pc < endian(psh[progsegs[i]].sh_addr);pc++)	/* align section */
  	{
  		
  			if(verbose) printf(".");
  			result = fwrite(&null,1,1,pbinfile);  	                /* write NULL to file                  */
  		
  	}
  	
  	
  	result = fwrite((pelf + endian(psh[progsegs[i]].sh_offset)),1,endian(psh[progsegs[i]].sh_size),pbinfile);  	/* write section to file                  */
  	pc +=  endian(psh[progsegs[i]].sh_size);						/* advance pc                             */
  	
  	if(verbose) printf(" %d (0x%08x) bytes written\n",result,result);
  	
 }
 
 // -- add relocations *********************************************************************
	// get .bss-segment start addresses:
	
	unsigned long _text  = get_section_offset_by_name(get_elf32_header((void*)pelf), ".text");
	unsigned long _data  = get_section_offset_by_name(get_elf32_header((void*)pelf), ".data");
	unsigned long _bss  = get_section_offset_by_name(get_elf32_header((void*)pelf), ".bss");
		

	unsigned long _text_size = get_section_size_by_name(get_elf32_header((void*)pelf), ".text");
	unsigned long _data_size = get_section_size_by_name(get_elf32_header((void*)pelf), ".data");
	unsigned long _bss_size  = get_section_size_by_name(get_elf32_header((void*)pelf), ".bss");
	unsigned long _prg_size = _text_size+_data_size+_bss_size;

	printf("\n \'text\' starts at 0x%08lx (size 0x%08lx / %4ld KByte)\n",_text, _text_size, _text_size/1024);
	printf(  " \'data\' starts at 0x%08lx (size 0x%08lx / %4ld KByte)\n",_data, _data_size, _data_size/1024);
	printf(  " \'bss\'  starts at 0x%08lx (size 0x%08lx / %4ld KByte)\n",_bss, _bss_size, _bss_size/1024);
	printf("\n                     program size 0x%08lx / %4ld KByte\n",_prg_size, _prg_size/(unsigned long)1024 );
	
	
        if(addreloc) 
        {
	  
	  for(; pc < _bss ;pc++)	/* align section */
	  {
		  
			  result = fwrite(&null,1,1,pbinfile);  	                /* write NULL to file                  */
		  
	  }
	
	  unsigned char MAGIC0[] = {0xDE,0xAD,0xBE,0xAF}; 
	  unsigned char MAGIC1[] = {0x5A,0xA5,0x80,0x01};
	  unsigned long laddr = endian(loadaddr);	
	  result = fwrite(MAGIC0,1,4,pbinfile);  	                /* write MAGIC0 to file                  */
	  result = fwrite(MAGIC1,1,4,pbinfile);  	          	/* write MAGIC1 to file                  */		
	  result = fwrite(MAGIC0,1,4,pbinfile);  	                /* write MAGIC0 to file                  */	
		  
	  result = fwrite(&laddr,1,4,pbinfile);			/* save loadaddress 			*/
	  
	  long int npos; fgetpos(pbinfile,(fpos_t*)&npos);	/* placeholder for number of alocation entries (will be set after entries are written) */
	  unsigned long rr=0;	
	  result = fwrite(&rr,4,1,pbinfile);
	  
		  
	  // walk through relocs 
	  struct _entry *preloc = preloc_list, *plast;
	
	  printf("\n adding relocation info into bss segment ...\n");
	  while(preloc)
	  {
		  
		  // print to file:
		  
		  
		  switch(endian(preloc->type))
		  { 	  	
			  // 32-Bit Relocations:
			  case 1:  	/*R_68K_32";            Direct 32 bit  */		
			  // 16-Bit Relocations:	
			  case 2:  	/*R_68K_16";            Direct 16 bit  */			
			  // 8-bit Relocations:
			  case 3:  	/*R_68K_8";             Direct 8 bit  */									
				  //fprintf(freloc," 0x%08lx	0x%08lx		0x%08lx\n ",endian(preloc->offset),endian(preloc->type),endian(preloc->value));
				  if(vverbose) printf(" 0x%08lx	0x%08lx		0x%08lx\n ",endian(preloc->offset),endian(preloc->type),endian(preloc->value));		
				  result = fwrite(&(preloc->offset),1,4,pbinfile);
				  result = fwrite(&(preloc->type),1,4,pbinfile);  	              	
				  result = fwrite(&(preloc->value),1,4,pbinfile);  
				  rr++;	              	  	              	
				  break;
				  
			  // pc relative relocs need no further handling
			  case 4:  	/*R_68K_PC32";          PC relative 32 bit */
				  
			  case 5:  	/*R_68K_PC16";          PC relative 16 bit */				
				  
			  case 6:  	/*R_68K_PC8";           PC relative 8 bit */
				  //fprintf(freloc," 0x%08lx	0x%08lx		0x%08lx\n ",endian(preloc->offset),endian(preloc->type),endian(preloc->value));	
				  break;		
		  }
		  
		  plast = preloc;
		  preloc = preloc->pnext;		
	    }
		  
	    if(verbose) printf(" %ld relocations added (%ld bytes) ...\n",rr,rr*12);
	    else printf(" %ld relocations added (%ld bytes) ...\n",rr,rr*12);

	    rr = endian(rr);
	    //int nendpos = ftell(pbinfile);
	    fseek(pbinfile,npos,SEEK_SET);
	    result = fwrite(&rr,1,4,pbinfile);
	    fseek(pbinfile,0,SEEK_END);
	} else printf("\n no relocation info added !\n");
	//fclose(freloc); 
 // -------------	-----
 
 if(pbinfile) close(pbinfile);
 
 
 if(undefs) {
 	printf("\n WARNING: there are %ld undefined symbols :\n\n",undefs);
 	print_undef_comm_syms(get_elf32_header((void*)pelf));
 	}
 if(commons) printf("\n WARNING: there are %ld COMMON symbols ! \n Hint: Use gcc option -fno-common to have these symbols in the bss segment.\n\n",commons);
 if(nopic && !addreloc) printf("\n No PIC (position independent code) ! Load address is 0x%08lx !\n\n"
                                 " Hint: To generate PIC use gcc option -fPIC (GOTs/PLTs are not supported yet !)\n"
                                 "       or use option -r to add relocation information \n\n",loadaddr);
                                                                 
  else     printf("\n Code is position independent.\n\n");
 
 
 CleanUp();

 exit(0); 
}














void printversion(){
 printf(versioninfo);
}
void usage()
{
	printversion();
	
        printf("\nUsage: elf2bin [<options>] filename\n\n");
        printf("<options>:\n");
        printf("   -o <outputfile>             set output filename\n");
        printf("   -l <load-address>           absolute address, where program will be loaded (normaly taken from elf header)\n");
        printf("   -r                          add relocation info\n");
        printf("   -v                          run verbose\n");
        printf("   -vv                         run more verbose\n");
        printf("   -s                          strip non text/data sections (debugging information etc.)\n");  
        printf("   -d                          debug all tables\n");              
}

void CleanUp()
{
  /* free allocated memory */
  if(pelf)		free(pelf);
  
  /* close all open file handles */
  if(pbinfile)		close(pbinfile);
  if(pelffile)		close(pelffile);
  
  /* free any allocated memory */
  struct _entry *preloc = preloc_list, *plast;
  
  while(preloc)
	{
		plast = preloc;
		preloc = preloc->pnext;
		free(plast);
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

void dump_data(unsigned char *pdata, unsigned int n)
{
	unsigned int i,j=0;
	char c;
	
	if(pdata == NULL) return;
	
	
	printf(" hexdump ( %d bytes ):\n\n",n);
	printf("    0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F\n");
	
	for(i=0; (i*16)+j < n; i++)
	{	
		printf(" %2x ",i);
		
		for(j=0; j<=15 && ((i*16)+j < n); j++)
		{
			printf("%02x ", *(pdata+(i*16)+j) );
		}
		
		if(j<15)
			for(;j<=15;j++) printf("   ");
		
		printf("   ");
		
		for(j=0; j<=15 && ((i*16)+j < n); j++)
		{
			c = *(pdata+(i*16)+j);
		
			if(!isdigit(c) && !isalpha(c)) c = '.';
			
			printf("%c", c );
		}
		
		printf("\n");
		j=0;
	}
	
	printf("\n\n");
}




/* ----------------------- */

unsigned long endian(unsigned long val){

 return ((val & 0xFF000000) >> 24) + ((val & 0x00FF0000) >> 8) + ((val & 0x0000FF00) << 8) + ((val & 0x000000FF) << 24);

}

static Elf32_Ehdr* get_elf32_header(void *address)
/* checks if address points to a valid Elf32 header and returns pointer to Elf32_Ehdr, NULL otherwise */
{
	if(address == NULL) return NULL;
	
	Elf32_Ehdr* hdr = (Elf32_Ehdr*)address;
	
	if(hdr->e_ident[EI_MAG0] != ELFMAG0) return NULL;
	if(hdr->e_ident[EI_MAG1] != ELFMAG1) return NULL;
	if(hdr->e_ident[EI_MAG2] != ELFMAG2) return NULL;
	if(hdr->e_ident[EI_MAG3] != ELFMAG3) return NULL;
	
	
	return address;
}

void do_relocations(Elf32_Ehdr* elf_hdr, unsigned long loadaddr)
{
	unsigned int i;
	
	if(elf_hdr== NULL) return;
	
	unsigned long number = endian(((unsigned long)elf_hdr->e_shnum) << 16);		/* number of section headers      */	
	unsigned long shoffset = endian(elf_hdr->e_shoff);				/* offset to section header table */
	
	Elf32_Shdr *psh = (Elf32_Shdr *) ((unsigned long)elf_hdr+shoffset);	
	
	
	for(i=0;i<number; i++,psh++)
	{
		
		switch( endian(psh->sh_type) )
		{
			case SHT_RELA: do_rela(elf_hdr, i, SHT_RELA, loadaddr); break;  /* used in m68k systems (addendum in relocation table) 	*/
			case SHT_REL : do_rela(elf_hdr, i, SHT_REL, loadaddr); break;   /* used in IA32 systems (addendum at relocation) 		*/
		}
	}
}



/*

*/
void print_nopics(Elf32_Ehdr* elf_hdr, unsigned int section, unsigned long reltype, unsigned long loadaddr)
{
	if(elf_hdr== NULL) return;
	
	unsigned long number = endian(((unsigned long)elf_hdr->e_shnum) << 16);		/* number of section headers      */
	unsigned long size = endian(((unsigned long)elf_hdr->e_shentsize) << 16);	/* size of elf headers (should be equal sizeof(Elf32_Shdr) */
	unsigned long shoffset = endian(elf_hdr->e_shoff);				/* offset to section header table */
	
	Elf32_Shdr *psh = (Elf32_Shdr *) ((unsigned long)elf_hdr+shoffset);		/* points to start of section headers */
	Elf32_Shdr *pRelaHdr = &psh[section];						/* points to RELA header in question */
	unsigned int progindx = endian(pRelaHdr->sh_info);				/* index of section header that needs relocation, should be of type PROGBITS */
	unsigned int symtabindx = endian(pRelaHdr->sh_link);				/* index of section header that holds the relevant symboltable */
	Elf32_Shdr *pProgHdr = &psh[progindx];						/* points to PROGBITS header that need relocation */
	Elf32_Shdr *pSymTabHdr = &psh[symtabindx];					/* points to SymbolTable header */
	unsigned int strtabindx = endian(pSymTabHdr->sh_link);				/* index of section header that holds the stringtable */
	Elf32_Shdr *pStrTabHdr = &psh[strtabindx];					/* points to StringTable header */
		
	
	
	if(section > number) return;
	
	Elf32_Rela * pRelocTab = (Elf32_Rela * )((unsigned long)elf_hdr + endian(pRelaHdr->sh_offset)); /* pRelocTab points to relocation table */
	Elf32_Sym* pSymTab = (Elf32_Sym*)((unsigned long)elf_hdr + endian(pSymTabHdr->sh_offset));	/* pSymTab points to Symbol Table */
	char* pStrTab = (char*)((unsigned long)elf_hdr + endian(pStrTabHdr->sh_offset));		/* pStrTab points to String Table */
	unsigned char* pProg = (unsigned char*)((unsigned long)elf_hdr + endian(pProgHdr->sh_offset));	/* pProg points to Prog */	
	
	unsigned int nrelas = endian(pRelaHdr->sh_size) / sizeof(Elf32_Rela);				/* number of relocations to process */
	
	unsigned int ii;
	unsigned long type,offset,value,symval,shindx,symindx,stindx,addend;
	
	Elf32_Rela *relas;
		
	
	/* get section header string table */	
	Elf32_Shdr *pShStrTabHdr = (Elf32_Shdr *)((unsigned long)psh + endian(((unsigned long)elf_hdr->e_shstrndx) << 16)*sizeof(Elf32_Shdr));  
							/* pShStrTabHdr points to section header of .shstrtab */
	
	char* pShStrTab = (char*)((unsigned long)elf_hdr + endian(pShStrTabHdr->sh_offset)); /* pShStrTab points to section header string table */
	
	char *pSymName;
	const char  *rtype;
	
	for(ii=0,relas = pRelocTab; ii< nrelas; ii++,relas++)
	 {
	 	offset = endian(relas->r_offset);
	 	type = ELF32_R_TYPE(endian(relas->r_info));
	 	
	 	shindx = ELF32_R_SYM (endian(relas->r_info)); // section header index, point to section header which in turn points to ShStrTab via index sh_name
	 	symval = endian(pSymTab[shindx].st_value); 
	 	
	 	
	 	// compute which name the symbol has ....
	 	if(endian(pSymTab[shindx].st_name) == 0)	// if ==0 the symbol name is a section name, look in .shstrtab
	 	{ 	
	 		pSymName = &pShStrTab[endian(psh[shindx].sh_name)];
	 	} 
	 	else if(pStrTab == NULL)			// otherwise look for the symbol name in the .strtab
	 	{
	 		sprintf(pSymName,"<string table index %3ld>", endian(pSymTab[shindx].st_name) );   // if not present, print out the index
	 	}
	 	else
	 	{
	 		pSymName = &pStrTab[endian(pSymTab[shindx].st_name)];	
	 	}
	 	
	 	addend = endian(relas->r_addend);
	 	
	 	switch (endian(((unsigned long)elf_hdr->e_machine) << 16))
	 	{
	 		case EM_68K:
		  		switch (type)
		  		{
		  			case 1:	/*R_68K_32";            Direct 32 bit  */
		  			case 2: /*R_68K_16";            Direct 16 bit  */
		  			case 3: /*R_68K_8";             Direct  8 bit  */
		  			printf(" 0x%08lx  0x%08lx   %-19s 0x%08lx   %-20s   +%ld\n",
					 		offset, 						/* Offset 			*/
					 		type, 							/* Info   			*/
					 		rtype,							/* R-Type   			*/
					 		symval,							/* SymValue  			*/
					 		pSymName,						/* SymName  			*/ 		
					 		addend);						/* Addendum 			*/
		  		}
		  		break;
			default: printf(" 0x%08lx  0x%08lx   %-19s 0x%08lx   %-20s   +%ld\n",
					 		offset, 						/* Offset 			*/
					 		type, 							/* Info   			*/
					 		rtype,							/* R-Type   			*/
					 		symval,							/* SymValue  			*/
					 		pSymName,						/* SymName  			*/ 		
					 		addend);						/* Addendum 			*/
		  }					 	
 
	 }
}




void add_bss_reloc(unsigned long offset, unsigned long type, unsigned long value)
{
	struct _entry *preloc = preloc_list, *plast=NULL;
			
	
	while(preloc)
	{
		plast = preloc;
		preloc = preloc->pnext;
	}
	
	
	preloc = (struct _entry *)malloc(sizeof(struct _entry));
	
	if(!preloc)
	{
		printf(" memory allocation error in add_bss_reloc !\n");
		CleanUp();
		exit(1);
	}
	
	
	preloc->offset  = offset;
	preloc->type    = type;
	preloc->value   = value;
	preloc->pnext	= NULL;
	
	
	if(plast) plast->pnext = preloc;
	else preloc_list = preloc;

	if(verbose && (endian(type) == R_68K_32))
	{
	        printf(" Reloc Type %s with value 0x%08lx at 0x%08lx added to bss segment.\n",elf_m68k_reloc_type(endian(type)),
	                                                                                        endian(value),endian(offset));
	        printf("-------------------------------------------------------------------------------------------------------------------------\n");
	}
	
}

unsigned long get_section_offset_by_name(Elf32_Ehdr* elf_hdr, char* name)
{
	int i;
	unsigned long number = endian(((unsigned long)elf_hdr->e_shnum) << 16);		/* number of section headers      */
	unsigned long shoffset = endian(elf_hdr->e_shoff);				/* offset to section header table */
	Elf32_Shdr *psh = (Elf32_Shdr *) ((unsigned long)elf_hdr+shoffset);		/* points to start of section headers */
	
	Elf32_Shdr *pShStrTabHdr = (Elf32_Shdr *)((unsigned long)psh + endian(((unsigned long)elf_hdr->e_shstrndx) << 16)*sizeof(Elf32_Shdr));  
						/* pShStrTabHdr points to section header of .shstrtab */

	char* pShStrTab = (char*)((unsigned long)elf_hdr + endian(pShStrTabHdr->sh_offset)); /* pShStrTab points to section header string table */

	for(i=0;i<number; i++)
	 {
	 	if(strstr(&pShStrTab[endian(psh[i].sh_name)],name)) {			// section "name"				
			return endian(psh[i].sh_addr);
		}
	}
}

unsigned long get_section_size_by_name(Elf32_Ehdr* elf_hdr, char* name)
{
	int i;
	unsigned long number = endian(((unsigned long)elf_hdr->e_shnum) << 16);		/* number of section headers      */
	unsigned long shoffset = endian(elf_hdr->e_shoff);				/* offset to section header table */
	Elf32_Shdr *psh = (Elf32_Shdr *) ((unsigned long)elf_hdr+shoffset);		/* points to start of section headers */
	
	Elf32_Shdr *pShStrTabHdr = (Elf32_Shdr *)((unsigned long)psh + endian(((unsigned long)elf_hdr->e_shstrndx) << 16)*sizeof(Elf32_Shdr));  
						/* pShStrTabHdr points to section header of .shstrtab */

	char* pShStrTab = (char*)((unsigned long)elf_hdr + endian(pShStrTabHdr->sh_offset)); /* pShStrTab points to section header string table */

	for(i=0;i<number; i++)
	 {
	 	if(strstr(&pShStrTab[endian(psh[i].sh_name)],name)) {			// section "name"				
			return endian(psh[i].sh_size);
		}
	}
}

void do_rela(Elf32_Ehdr* elf_hdr, unsigned int section, unsigned long reltype, unsigned long loadaddr)
{
	if(elf_hdr== NULL) return;	 
	 
	if(vverbose) printf(" do_rela: section %d\n", section);
	
	unsigned long number = endian(((unsigned long)elf_hdr->e_shnum) << 16);		/* number of section headers      */
	unsigned long size = endian(((unsigned long)elf_hdr->e_shentsize) << 16);	/* size of elf headers (should be equal sizeof(Elf32_Shdr) */
	unsigned long shoffset = endian(elf_hdr->e_shoff);				/* offset to section header table */
	
	Elf32_Shdr *psh = (Elf32_Shdr *) ((unsigned long)elf_hdr+shoffset);		/* points to start of section headers */
	Elf32_Shdr *pRelaHdr = &psh[section];						/* points to RELA header in question */
	unsigned int progindx = endian(pRelaHdr->sh_info);				/* index of section header that needs relocation, should be of type PROGBITS */
	unsigned int symtabindx = endian(pRelaHdr->sh_link);				/* index of section header that holds the relevant symboltable */
	Elf32_Shdr *pProgHdr = &psh[progindx];						/* points to PROGBITS header that need relocation */
	Elf32_Shdr *pSymTabHdr = &psh[symtabindx];					/* points to SymbolTable header */
	unsigned int strtabindx = endian(pSymTabHdr->sh_link);				/* index of section header that holds the stringtable */
	Elf32_Shdr *pStrTabHdr = &psh[strtabindx];					/* points to StringTable header */
		
	
	
	if(section > number) return;
	
	Elf32_Rela * pRelocTab = (Elf32_Rela * )((unsigned long)elf_hdr + endian(pRelaHdr->sh_offset)); /* pRelocTab points to relocation table */
	Elf32_Sym* pSymTab = (Elf32_Sym*)((unsigned long)elf_hdr + endian(pSymTabHdr->sh_offset));	/* pSymTab points to Symbol Table */
	char* pStrTab = (char*)((unsigned long)elf_hdr + endian(pStrTabHdr->sh_offset));		/* pStrTab points to String Table */
	unsigned char* pProg = (unsigned char*)((unsigned long)elf_hdr + endian(pProgHdr->sh_offset));	/* pProg points to Prog */	
	
	unsigned int nrelas = endian(pRelaHdr->sh_size) / sizeof(Elf32_Rela);				/* number of relocations to process */
	
	unsigned int ii;
	unsigned long type,offset,value,symval,shindx,symindx,stindx,addend;
	
	Elf32_Rela *relas;
		
	
	/* get section header string table */	
	Elf32_Shdr *pShStrTabHdr = (Elf32_Shdr *)((unsigned long)psh + endian(((unsigned long)elf_hdr->e_shstrndx) << 16)*sizeof(Elf32_Shdr));  
							/* pShStrTabHdr points to section header of .shstrtab */
	
	char* pShStrTab = (char*)((unsigned long)elf_hdr + endian(pShStrTabHdr->sh_offset)); /* pShStrTab points to section header string table */
	
	char *pSymName;
	const char  *rtype;
	
	unsigned int target_section = endian(psh[section].sh_info); // index of section, where the relocation is done
	
	if(verbose)  /* print relocation table */
	{						
		
		printf(" Relocation section [%d] \' %s \' at offset 0x%08lx contains %d entries:\n", section, &pShStrTab[endian(pRelaHdr->sh_name)] , 
													endian(pRelaHdr->sh_offset), nrelas); 
 		printf(" Offset      Info         Type            Symbol's Value   Symbol's Name          Addend\n");
 		
 		
 		for(ii=0,relas = pRelocTab; ii< nrelas; ii++,relas++)
		 {
		 	offset = endian(relas->r_offset);
		 	type = ELF32_R_TYPE(endian(relas->r_info));
		 	
		 	shindx = ELF32_R_SYM (endian(relas->r_info)); // section header index, point to section header which in turn points to ShStrTab via index sh_name
		 	symval = endian(pSymTab[shindx].st_value); 
		 	
		 	
		 	// compute which name the symbol has ....
		 	if(endian(pSymTab[shindx].st_name) == 0)	// if ==0 the symbol name is a section name, look in .shstrtab
		 	{ 	
		 		pSymName = &pShStrTab[endian(psh[shindx].sh_name)];
		 	} 
		 	else if(pStrTab == NULL)			// otherwise look for the symbol name in the .strtab
		 	{
		 		sprintf(pSymName,"<string table index %3ld>", endian(pSymTab[shindx].st_name) );   // if not present, print out the index
		 	}
		 	else
		 	{
		 		pSymName = &pStrTab[endian(pSymTab[shindx].st_name)];	
		 	}
		 	
		 	addend = endian(relas->r_addend);
		 	
		 	switch (endian(((unsigned long)elf_hdr->e_machine) << 16))
		 	{
		 		case EM_68K:
			  		rtype = elf_m68k_reloc_type (type);	  		
			  		break;
				default: rtype = "NON 68K Type";
		 	}
		 
		 	printf(" 0x%08lx  0x%08lx   %-19s 0x%08lx   %-20s   +%ld\n",
		 		offset, 						/* Offset 			*/
		 		type, 							/* Info   			*/
		 		rtype,							/* R-Type   			*/
		 		symval,							/* SymValue  			*/
		 		pSymName,						/* SymName  			*/ 		
		 		addend);						/* Addendum 			*/
		 }
		 printf("\n");
		 //	printf(" Program will be loaded at 0x%08lx\n\n",loadaddr);
	}
	
	
	/* do the relocation ... */
	
	if(vverbose) printf(" relocations done:\n");
	
	for(ii=0,relas = pRelocTab; ii< nrelas; ii++,relas++)
	 {
	 	
	 	offset = endian(relas->r_offset);			// relocation position
	 	type   = ELF32_R_TYPE(endian(relas->r_info));		// relocation type (R_68K_32, R_68K_PC32 ...)
	 	stindx = ELF32_R_SYM (endian(relas->r_info));    	// symbol table index, point to symbol in symbol table
	 	symval = endian(pSymTab[stindx].st_value); 		// symbols value in relocation table
	 	shindx = endian(pSymTab[stindx].st_shndx << 16);	// shindex is needed if st_name in .symtab = 0	
	 	
	
	 	// 1. compute which address value to take ...	
	 	// endian(psh->sh_type)
	 	
	 	//if(endian(psh[shindx].sh_type) != SHT_PROGBITS) continue;
	 	
		if(endian(pSymTab[stindx].st_name) == 0)			
	 							// if st_name is 0 the symbol name references a section, so look in .shstrtab and use sh_addr of particular section	 							
	 	{ 	
		 	if(vverbose)
		 	{
		 	  
		 	  printf("A:(value=addendum+sectionoffset+loadaddr) shindx = 0x%08lx (%s,%s) ==> Section offset = 0x%08lx\n",
		 	    shindx,
		 	    &pShStrTab[endian(psh[shindx].sh_name)],get_section_type_name(endian(psh[shindx].sh_type)), // section where the relocation point's to
		 	    endian(psh[shindx].sh_addr));
		 	}
		 	    
	 		value = endian(psh[shindx].sh_addr);  	// fetch value from section offset DAS IST DER SECTION OFFSET !!! -TS-
	 		pSymName = &pShStrTab[endian(psh[shindx].sh_name)];
	 	} 
	 	else if(pStrTab == NULL)			// otherwise take the st_value from symbol table .symtab
	 	{
	 		value = 0;  			// if not present, set relocation to 0
	 		sprintf(pSymName,"<string table index %3ld>", endian(pSymTab[shindx].st_name) );   // if not present, print out the index
	 	}
	 	else
	 	{
	 		
	 		switch(shindx)
			{		
		  		case SHN_UNDEF:          	/* Undefined section */
				case SHN_LORESERVE:        	/* Start of reserved indices */
				//case SHN_LOPROC:        	/* Start of processor-specific */  
				case SHN_HIPROC:          	/* End of processor-specific */   
				case SHN_LOOS:        		/* Start of OS-specific */
				case SHN_HIOS:          	/* End of OS-specific */
				case SHN_ABS:          		/* Associated symbol is absolute */
				case SHN_COMMON:       		/* Associated symbol is common --> st_value only holds alignment info*/
							
				case SHN_XINDEX:         	/* Index is in extra table.  */
				//case SHN_HIRESERVE:       	/* End of reserved indices */	
						if(vverbose) printf("B:(value=addendum+symval+loadaddr) shindx = 0x%08lx (%s,%s) ==> Section offset = 0x%08lx\n",
						                        shindx,
						                        &pShStrTab[endian(psh[shindx].sh_name)],get_section_type_name(endian(psh[shindx].sh_type)),
						                        (long unsigned int)0);
						value = endian(pSymTab[stindx].st_value);		
						break;	
				default: 
						if(vverbose) printf("C:(value=addendum+symval+sectionoffset+loadaddr) shindx = 0x%08lx (%s,%s) ==> Section offset = 0x%08lx\n",
						                     shindx,
						                     &pShStrTab[endian(psh[shindx].sh_name)],get_section_type_name(endian(psh[shindx].sh_type)),
                                                                     endian(psh[shindx].sh_addr));
						value = endian(pSymTab[stindx].st_value) + endian(psh[shindx].sh_addr); // = "Symbol-Value" + "Section-Offset"
			}
			
	 	}
	 	
	 	
	 	
	 	// 2. get addendum
	 	switch(reltype)
	 	{
	 	
	 	  case SHT_RELA:				// get addendum (we assume RelocationSectionHeader Type = RELA !! which is ok for M68k architecture)		
	 		addend = endian(relas->r_addend);	
	 		break;
	 	
	 	  case SHT_REL:				// if this type was 'REL' we would have to: addend = *offset (i.e. the addendum is stored at the relocation position) 	
	 		switch(type)
	 		{	 // 32-bit relocation
	 			case 1:                                         /*R_68K_32";            Direct 32 bit  */ 
	 			case 4: addend =  *(pProg+offset  ) << 24;      /*R_68K_PC32";          PC relative 32 bit */
	 				addend += *(pProg+offset+1) << 16;
	 				addend += *(pProg+offset+2) <<  8;
	 				addend += *(pProg+offset+3);
	 				break;
	 			// 16-bit relocations	
	 			case 2:                                         /*R_68K_16";            Direct 16 bit  */
	 			case 5: addend =  *(pProg+offset  ) << 16;      /*R_68K_PC16";          PC relative 16 bit */
	 				addend += *(pProg+offset+1);
	 				break;
	 			// 8-bit relocations	
	 			case 3:                                         /*R_68K_8";             Direct 8 bit  */
	 			case 6: addend =  *(pProg+offset);              /*R_68K_PC8";           PC relative 8 bit */
	 				break;
	 		}
	 		break;
	 	}
	 			
	 	
	 	
	 	
	 	// 3. store relocation data...
	 	if(vverbose) {
	 	        printf(" value = 0x%08lx | addend = 0x%08lx | offset = 0x%08lx | loadaddr = 0x%08lx | sh_addr = 0x%08lx\n\n",
	 	                value,addend,offset,loadaddr,endian(psh[shindx].sh_addr) );	 	        
	 	}
	 	switch(type)
	 	{
	 	         	  	
	 	  	// 32-Bit Relocations:
			case 1:  	/*R_68K_32";            Direct 32 bit  */							
				value = value + addend + loadaddr;	
				nopic = 1;
				if(vverbose) printf(" [%08lx](%s +0x%08lx=0x%08lx) <= %08lx   (_32)\n",
				                offset,
				                &pShStrTab[endian(psh[target_section].sh_name)],
				                endian(psh[target_section].sh_addr),
				                offset + endian(psh[target_section].sh_addr),
				                value); 
				
				if(endian(psh[target_section].sh_type) == SHT_PROGBITS)
 				  add_bss_reloc( endian(offset + endian(psh[target_section].sh_addr)) , endian(type), endian(value-loadaddr));
				//add_bss_reloc(offset, type, value);
				
				//if(verbose)
				//{
				//  rtype = elf_m68k_reloc_type (type);
				//  printf(" 0x%08lx  0x%08lx   %-19s 0x%08lx   %-20s   +%ld\n",
				//	 		offset, 						/* Offset 			*/
				//	 		type, 							/* Info   			*/
				//	 		rtype,							/* R-Type   			*/
				//	 		symval,							/* SymValue  			*/
				//	 		pSymName,						/* SymName  			*/ 		
				//	 		addend);						/* Addendum 			*/
				//}
				 
				*(pProg+offset)   = (unsigned char)((value & 0xFF000000) >> 24);
				*(pProg+offset+1) = (unsigned char)((value & 0x00FF0000) >> 16);
				*(pProg+offset+2) = (unsigned char)((value & 0x0000FF00) >> 8);
				*(pProg+offset+3) = (unsigned char)(value & 0x000000FF);
				break;
			case 4:  	/*R_68K_PC32";          PC relative 32 bit */
			        
				value = value + addend - offset;
				
				if(vverbose) printf(" [%08lx](%s+0x%08lx) <= %08lx   (_PC32)\n",
				                offset,
				                &pShStrTab[endian(psh[target_section].sh_name)],
				                endian(psh[target_section].sh_addr),
				                value);
				
				if(endian(psh[target_section].sh_type) == SHT_PROGBITS)
				  add_bss_reloc(endian(offset + endian(psh[target_section].sh_addr)), endian(type), endian(value));
				
				*(pProg+offset)   = (unsigned char)((value & 0xFF000000) >> 24);
				*(pProg+offset+1) = (unsigned char)((value & 0x00FF0000) >> 16);
				*(pProg+offset+2) = (unsigned char)((value & 0x0000FF00) >> 8);
				*(pProg+offset+3) = (unsigned char)(value & 0x000000FF);			
				break;
			// 16-Bit Relocations:	
			case 2:  	/*R_68K_16";            Direct 16 bit  */
				value = value + addend + loadaddr;
				nopic = 1;	
				if(vverbose) printf(" [%08lx](%s+0x%08lx) <= %04lx   (_16)\n",
				                offset,
				                &pShStrTab[endian(psh[target_section].sh_name)],
				                endian(psh[target_section].sh_addr),
				                value);
				
				if(endian(psh[target_section].sh_type) == SHT_PROGBITS)
				  add_bss_reloc(endian(offset + endian(psh[target_section].sh_addr)), endian(type), endian(value-loadaddr));
				
				if( (value >> 16) && 0xffff)
				 if( (value >> 16) && 0xffff != 0xffff) // i.e. value is negativ
				   printf(" value too large for R_68K_16 relocation: symbol= %-20s value=0x%08lx\n"\
				          "                                          [%08lx](%s+0x%08lx) <= %04lx   (_16)\n",
				                pSymName,value,offset,
				                &pShStrTab[endian(psh[target_section].sh_name)],
				                endian(psh[target_section].sh_addr),
				                value);
				 
			
				*(pProg+offset) = (unsigned char)((value & 0x0000FF00) >> 8);
				*(pProg+offset+1) = (unsigned char)(value & 0x000000FF);
				break;
			case 5:  	/*R_68K_PC16";          PC relative 16 bit */
			
			        
				value = value + addend - offset;
				 
				if(vverbose) printf(" [%08lx](%s+0x%08lx) <= %04lx   (_PC16)\n",
				                offset,
				                &pShStrTab[endian(psh[target_section].sh_name)],
				                endian(psh[target_section].sh_addr),
				                value);
				
				if(endian(psh[target_section].sh_type) == SHT_PROGBITS)
				  add_bss_reloc(endian(offset + endian(psh[target_section].sh_addr)), endian(type), endian(value));
				
				if( (value >> 16) && 0xffff)
				 if( (value >> 16) && 0xffff != 0xffff) // i.e. value is negativ 
				        printf(" value too large for R_68K_PC16 relocation : symbol=%-20s value=0x%08lx\n"\
				               "                                            [%08lx](%s+0x%08lx) <= %04lx   (_16)\n"
				                        ,pSymName,value,offset,
				                        &pShStrTab[endian(psh[target_section].sh_name)],
				                        endian(psh[target_section].sh_addr),
				                        value);
			
				*(pProg+offset) = (unsigned char)((value & 0x0000FF00) >> 8);
				*(pProg+offset+1) = (unsigned char)(value & 0x000000FF);
				break;
			// 8-bit Relocations:
			case 3:  	/*R_68K_8";             Direct 8 bit  */		
				value = value + addend + loadaddr;
				nopic = 1;	
				if(vverbose) printf(" [%08lx](%s+0x%08lx) <= %02lx   (_8)\n",
				                offset,
				                &pShStrTab[endian(psh[target_section].sh_name)],
				                endian(psh[target_section].sh_addr),
				                value);
				
				if(endian(psh[target_section].sh_type) == SHT_PROGBITS)
				  add_bss_reloc(endian(offset + endian(psh[target_section].sh_addr)), endian(type), endian(value-loadaddr));
				
				if( (value >> 8) && 0xffffff)
				 if( (value >> 8) && 0xffffff != 0xffffff) // i.e. value is negativ
                                   printf(" value to large for R_68K_8 relocation : symbol=%-20s value=0x%08lx\n",pSymName,value);
			
				*(pProg+offset) = (unsigned char)(value & 0x000000FF);
				break;
			case 6:  	/*R_68K_PC8";           PC relative 8 bit */
			        
				value = value + addend - offset;
				 
				if(vverbose) printf(" [%08lx](%s+0x%08lx) <= %02lx   (_PC8)\n",
				                offset,
				                &pShStrTab[endian(psh[target_section].sh_name)],
				                endian(psh[target_section].sh_addr),
				                value);
				
				if(endian(psh[target_section].sh_type) == SHT_PROGBITS)
				  add_bss_reloc(endian(offset + endian(psh[target_section].sh_addr)), endian(type), endian(value));
				
				
				if( (value >> 8) && 0xffffff)
				 if( (value >> 8) && 0xffffff != 0xffffff) // i.e. value is negativ
				  printf(" value to large for R_68K_PC8 relocation : symbol=%-20s value=0x%08lx\n",pSymName,value);
			
				*(pProg+offset) = (unsigned char)(value & 0x000000FF);
				break;
			
			
			// other relocations are not (YET) supported:	
			
			/*
				siehe uCLinux/user/gdb/bfd/elf32-m68k.c
				
				GOT = Global Offset Table
				PLT = Procedure Linkage Table
			*/
			
			case 0:  	/*R_68K_NONE";          No reloc */
			case 7:  	/*R_68K_GOT32";         32 bit PC relative GOT entry */
			case 8:  	/*R_68K_GOT16";         16 bit PC relative GOT entry */
			case 9:  	/*R_68K_GOT8";          8 bit PC relative GOT entry */
			case 10:  	/*R_68K_GOT32O";        32 bit GOT offset */
			case 11:  	/*R_68K_GOT16O";        16 bit GOT offset */
			case 12:  	/*R_68K_GOT8O";         8 bit GOT offset */
			case 13:  	/*R_68K_PLT32";         32 bit PC relative PLT address */
			case 14:  	/*R_68K_PLT16";         16 bit PC relative PLT address */
			case 15:  	/*R_68K_PLT8";          8 bit PC relative PLT address */
			case 16:  	/*R_68K_PLT32O";        32 bit PLT offset */
			case 17:  	/*R_68K_PLT16O";        16 bit PLT offset */
			case 18:  	/*R_68K_PLT8O";         8 bit PLT offset */
			case 19:  	/*R_68K_COPY";          Copy symbol at runtime */
			case 20:  	/*R_68K_GLOB_DAT";      Create GOT entry */
			case 21:  	/*R_68K_JMP_SLOT";      Create PLT entry */
			case 22:  	/*R_68K_RELATIVE";      Adjust by program base */
	 		 /* These are GNU extensions to enable C++ vtable garbage collection.  */
			case 23:  	/*R_68K_GNU_VTINHERIT"; */
			case 24:  	/*R_68K_GNU_VTENTRY"; */
			case 25:  	/*R_68K_max"; */
			default:  	/*R_68K_UNKNOWN"; */
				printf(" error unsupported relocation (%s)\n",elf_m68k_reloc_type(type));
				CleanUp();
				exit(1);
	 	}
	 	
	 	switch (endian(((unsigned long)elf_hdr->e_machine) << 16))
	 	{
	 		case EM_68K:	  			  		
		  		break;
			default: 
				printf(" error not a m68k machine\n");
				CleanUp();
				exit(1);
	 	} 
	 	
	 }
	 
	 
	printf("\n");	
	
	
		
}

/* ------------------------------------------------- print functions ------------------------------------------------ */

void print_elf_hdr(Elf32_Ehdr* elf_hdr){

 unsigned int i;
 
 if(elf_hdr == NULL) return;
 
 // MAGIC
 printf(" Magic: "); for(i=0; i < EI_NIDENT; i++) {printf("%02x ",elf_hdr->e_ident[i]);}  printf("\n");
 // CLASS
 printf(" Class:\t\t\t\t\t"); 
 switch( elf_hdr->e_ident[EI_CLASS] )
 {
 	case ELFCLASSNONE: 	printf("NO ELF\n"); break;
 	case ELFCLASS32:	printf("ELF32\n");  break;
 	case ELFCLASS64: 	printf("ELF64\n");  break;
 	default:		printf("0x%02x\n",elf_hdr->e_ident[EI_CLASS]); break;
 }
 //MACHINE/ARCHITECTURE
 printf(" Data:\t\t\t\t\t");
 switch(  elf_hdr->e_ident[EI_DATA] )
 {
 	case ELFDATANONE:	printf("Invalid data encoding\n");break;
	case ELFDATA2LSB:	printf("2's complement, little endian\n");break;
	case ELFDATA2MSB:	printf("2's complement, big endian\n");break;
	case ELFDATANUM	:       printf("ELFDATANUM\n");break;
	default: printf("0x%02x\n",elf_hdr->e_ident[EI_DATA] ); break;
 } 
 //VERSION
 printf(" Version:\t\t\t\t%d\n", elf_hdr->e_ident[EI_VERSION]);
 //OS/ABI
 printf(" OS/ABI:\t\t\t\t");
 switch(  elf_hdr->e_ident[EI_OSABI] )
 {
 	case ELFOSABI_NONE	: printf("UNIX System V ABI\n"); break;
 	//case ELFOSABI_SYSV	: printf("Alias.\n"); break;
 	case ELFOSABI_HPUX	: printf("HP-UX\n"); break;
 	case ELFOSABI_NETBSD	: printf("NetBSD.\n"); break;
 	case ELFOSABI_LINUX	: printf("Linux.\n"); break;
 	case ELFOSABI_SOLARIS	: printf("Sun Solaris.\n"); break;
 	case ELFOSABI_AIX	: printf("IBM AIX.\n"); break;
 	case ELFOSABI_IRIX	: printf("SGI Irix.\n"); break;
 	case ELFOSABI_FREEBSD	: printf("FreeBSD.\n"); break;
 	case ELFOSABI_TRU64	: printf("Compaq TRU64 UNIX.\n"); break;
 	case ELFOSABI_MODESTO	: printf("Novell Modesto.\n"); break;
 	case ELFOSABI_OPENBSD	: printf("OpenBSD.\n"); break;
 	case ELFOSABI_ARM	: printf("ARM v\n"); break;
 	case ELFOSABI_STANDALONE: printf("Standalone (embedded) application\n"); break;
 	default:		  printf("0x%02x\n",elf_hdr->e_ident[EI_OSABI]);

 }
 //ABI Version
 printf(" ABI Version:\t\t\t\t%d\n",elf_hdr->e_ident[EI_ABIVERSION]);
 //TYPE
 printf(" Type:\t\t\t\t\t");
 switch( endian(((unsigned long)elf_hdr->e_type) << 16) )
 {
	case ET_NONE	: printf("No file type \n"); break;
	case ET_REL	: printf("Relocatable file\n"); break;
	case ET_EXEC	: printf("Executable file\n"); break;
	case ET_DYN	: printf("Shared object file\n"); break;
	case ET_CORE	: printf("Core file\n"); break;
	case ET_NUM	: printf("Number of defined types\n"); break;
	case ET_LOOS	: printf("OS-specific range start\n"); break;
	case ET_HIOS	: printf("OS-specific range end\n"); break;
	case ET_LOPROC	: printf("Processor-specific range start\n"); break;
	case ET_HIPROC	: printf("Processor-specific range end\n"); break;
	default: printf("0x04lx\n",endian(((unsigned long)elf_hdr->e_type) << 16));


 }
 //MACHINE
 printf(" Machine:\t\t\t\t");
 switch(endian(((unsigned long)elf_hdr->e_machine) << 16))
 {
 	case EM_68K: printf("Motorola m68k family\n"); break;
 	default: printf("0x04lx\n",endian(((unsigned long)elf_hdr->e_machine) << 16)); // elf.h defines more !!
 }
 //VERSION
 printf(" ELF Version:\t\t\t\t%ld\n",endian(elf_hdr->e_version));
 // ENTRY POINT ADDRESS
 printf(" Entry point address:\t\t\t0x%08lx\n",endian(elf_hdr->e_entry));
 // START OF PROGRAM HEADERS
 printf(" Start of program headers:\t\t%ld (bytes into file)\n",endian(elf_hdr->e_phoff));
 // START OF SECTION HEADERS
 printf(" Start of section headers:\t\t%ld (bytes into file)\n",endian(elf_hdr->e_shoff));
 // FLAGS
 printf(" Flags:\t\t\t\t\t0x%08lx\n",endian(elf_hdr->e_flags));
 // SIZE OF THIS HEADER
 printf(" Size of ELF header:\t\t\t%ld (bytes)\n",endian(((unsigned long)elf_hdr->e_ehsize) << 16));
 // SIZE OF PROGRAM HEADERS
 printf(" Size of program headers:\t\t%ld (bytes)\n",endian(((unsigned long)elf_hdr->e_phentsize) << 16));
 // NUMBER OF PROGRAM HEADERS
 printf(" Number of program headers:\t\t%ld\n",endian(((unsigned long)elf_hdr->e_phnum) << 16));
 // SIZE OF SECTION HEADERS
 printf(" Size of section headers:\t\t%ld (bytes)\n",endian(((unsigned long)elf_hdr->e_shentsize) << 16));
 // NUMBER OF SECTION HEADERS
 printf(" Number of section headers:\t\t%ld\n",endian(((unsigned long)elf_hdr->e_shnum) << 16));
 // SECTION HEADER STRING TABLE INDEX
 printf(" Section header string table index:\t%ld\n",endian(((unsigned long)elf_hdr->e_shstrndx) << 16));
 
 printf("\n");
 
}


void print_sec_hdrs(Elf32_Ehdr* elf_hdr)
{
	unsigned int i;
	
	if(elf_hdr== NULL) return;
	
	unsigned long number = endian(((unsigned long)elf_hdr->e_shnum) << 16);
	unsigned long size = endian(((unsigned long)elf_hdr->e_shentsize) << 16);
	unsigned long shoffset = endian(elf_hdr->e_shoff);	
	
	Elf32_Shdr *psh = (Elf32_Shdr *) ((unsigned long)elf_hdr+shoffset);	
	
	
	if(shoffset == 0)
	{
		printf(" There are no section headers in this file\n\n");
		return;
	}
	
	if(size != sizeof(Elf32_Shdr)) return;
		
	/* get section header string table */
	
	Elf32_Shdr *pShStrTabHdr = (Elf32_Shdr *)((unsigned long)psh + endian(((unsigned long)elf_hdr->e_shstrndx) << 16)*sizeof(Elf32_Shdr));  
							/* pShStrTabHdr points to section header of .shstrtab */
	
	char* pShStrTab = (char*)((unsigned long)elf_hdr + endian(pShStrTabHdr->sh_offset)); /* pShStrTab points to section header string table */
	
	
	printf(" There are %ld sections of size %ld at offset 0x%08lx(%ld):\n\n",	number,size,shoffset,shoffset);
	
	printf(" [Nr]  Name             Type            Addr     Offset   Size     Flags  Link  Info Alingn   ES\n"); // EntitySize = Size of one Item, Size = Size of whole section
														        // number of entries = Size / EntSize
	for(i=0;i<number; i++,psh++)
	{
		
		printf(" [%2d] %-17s %-15s %08lx %08lx %08lx %-6s %2ld    %3lx   %2ld     0x%08lx\n", 
			i,&pShStrTab[endian(psh->sh_name)],get_section_type_name(endian(psh->sh_type)),endian(psh->sh_addr),
			  endian(psh->sh_offset),endian(psh->sh_size),get_elf_section_flags(endian(psh->sh_flags)),
			  endian(psh->sh_link),endian(psh->sh_info),endian(psh->sh_addralign),
			  endian(psh->sh_entsize));
	}
	
	printf ("\n Key to Flags: W (write), A (alloc), X (execute), M (merge), S (strings)\n");
  	printf ("               I (info), L (link order), O (extra OS processing required)\n");
  	printf ("               o (os specific), p (processor specific) x (unknown)\n\n");
	
}

void scan_sym_table(Elf32_Ehdr* elf_hdr)
{

	if(elf_hdr== NULL) return;
	
	unsigned long number = endian(((unsigned long)elf_hdr->e_shnum) << 16);		/* number of section headers      */
	
	unsigned long size = endian(((unsigned long)elf_hdr->e_shentsize) << 16);	/* size of elf headers (should be equal sizeof(Elf32_Shdr) */
	unsigned long shoffset = endian(elf_hdr->e_shoff);				/* offset to section header table */
	
	Elf32_Shdr *psh = (Elf32_Shdr *) ((unsigned long)elf_hdr+shoffset);		/* points to start of section headers */
	
	/* get section header string table */	
	Elf32_Shdr *pShStrTabHdr = (Elf32_Shdr *)((unsigned long)psh + endian(((unsigned long)elf_hdr->e_shstrndx) << 16)*sizeof(Elf32_Shdr));  
							/* pShStrTabHdr points to section header of .shstrtab */
	
	char* pShStrTab = (char*)((unsigned long)elf_hdr + endian(pShStrTabHdr->sh_offset)); /* pShStrTab points to section header string table */
	
	int i;

	for(i=0;i<number; i++)
 	{		

		if( endian(psh[i].sh_type) == SHT_SYMTAB ) 
		{		
			/* dump symbol table  */			
			Elf32_Shdr* pSymTabHdr = &psh[i];								/* points to SYMBOL header in question		*/ 
			Elf32_Sym* pSymTab = (Elf32_Sym*)((unsigned long)elf_hdr + endian(pSymTabHdr->sh_offset));	/* pSymTab points to Symbol Table */
			unsigned int nentries = endian(pSymTabHdr->sh_size) / sizeof(Elf32_Sym);			/* number of symbol table entries to process 	*/
					
			if(verbose)
			{
				printf(" Symbol table \' %s \' contains %d  entries:\n",&pShStrTab[endian(pSymTabHdr->sh_name)],nentries);
				printf("   Num:       Value   Size   Type        Bind        Vis        Ndx          Name\n");
			}
			
			int n;
			char *pSymName;
			unsigned int strtabindx = endian(pSymTabHdr->sh_link);				/* index of section header that holds the stringtable */
			Elf32_Shdr *pStrTabHdr = &psh[strtabindx];					/* points to StringTable header */
			char* pStrTab = (char*)((unsigned long)elf_hdr + endian(pStrTabHdr->sh_offset));		/* pStrTab points to String Table */

			const char* type,bind;
			
			for(n=0; n<nentries; n++)
			{
			
			   if(verbose)
			   {
				// compute which name the symbol has ....
			 	if(endian(pSymTab[n].st_name) == 0)	// if ==0 the symbol name is a section name, look in .shstrtab
			 	{ 	
			 		pSymName = &pShStrTab[endian(psh[n].sh_name)];
			 	} 
			 	else if(pStrTab == NULL)			// otherwise look for the symbol name in the .strtab
			 	{
			 		sprintf(pSymName,"<string table index %3ld>", endian(pSymTab[n].st_name) );   // if not present, print out the index
			 	}
			 	else
			 	{
			 		pSymName = &pStrTab[endian(pSymTab[n].st_name)];			 			
			 	}
			 	
			 	printf(" %5d   0x%08lx  %5ld   %-10s  %-10s  %-10s %-10s   %-20s \n", n, endian(pSymTab[n].st_value), endian(pSymTab[n].st_size) , 
									      get_symbol_type( ELF32_ST_TYPE(pSymTab[n].st_info) ),
									      get_symbol_bind( ELF32_ST_BIND(pSymTab[n].st_info) ),
									      get_symbol_visibility (ELF32_ST_VISIBILITY (pSymTab[n].st_other)),
									      get_symbol_shndx(endian(pSymTab[n].st_shndx << 16)), pSymName   );			 	
			    }
			    
			    if (endian(pSymTab[n].st_shndx << 16) == SHN_UNDEF && n != 0) undefs++;
			    if (endian(pSymTab[n].st_shndx << 16) == SHN_COMMON) commons++;
				
			}
						
								
		}
	
 	} 
	
	
	
	
//	unsigned int progindx = endian(pRelaHdr->sh_info);				/* index of section header that needs relocation, should be of type PROGBITS */
//	unsigned int symtabindx = endian(pRelaHdr->sh_link);				/* index of section header that holds the relevant symboltable */
//	Elf32_Shdr *pProgHdr = &psh[progindx];						/* points to PROGBITS header that need relocation */
//	Elf32_Shdr *pSymTabHdr = &psh[symtabindx];					/* points to SymbolTable header */
//	unsigned int strtabindx = endian(pSymTabHdr->sh_link);				/* index of section header that holds the stringtable */
//	Elf32_Shdr *pStrTabHdr = &psh[strtabindx];					/* points to StringTable header */

//	Elf32_Rela * pRelocTab = (Elf32_Rela * )((unsigned long)elf_hdr + endian(pRelaHdr->sh_offset)); /* pRelocTab points to relocation table */
//	Elf32_Sym* pSymTab = (Elf32_Sym*)((unsigned long)elf_hdr + endian(pSymTabHdr->sh_offset));	/* pSymTab points to Symbol Table */
//	char* pStrTab = (char*)((unsigned long)elf_hdr + endian(pStrTabHdr->sh_offset));		/* pStrTab points to String Table */
//	unsigned char* pProg = (unsigned char*)((unsigned long)elf_hdr + endian(pProgHdr->sh_offset));	/* pProg points to Prog */	

}


void print_undef_comm_syms(Elf32_Ehdr* elf_hdr)
{

	if(elf_hdr== NULL) return;
	
	unsigned long number = endian(((unsigned long)elf_hdr->e_shnum) << 16);		/* number of section headers      */
	
	unsigned long size = endian(((unsigned long)elf_hdr->e_shentsize) << 16);	/* size of elf headers (should be equal sizeof(Elf32_Shdr) */
	unsigned long shoffset = endian(elf_hdr->e_shoff);				/* offset to section header table */
	
	Elf32_Shdr *psh = (Elf32_Shdr *) ((unsigned long)elf_hdr+shoffset);		/* points to start of section headers */
	
	/* get section header string table */	
	Elf32_Shdr *pShStrTabHdr = (Elf32_Shdr *)((unsigned long)psh + endian(((unsigned long)elf_hdr->e_shstrndx) << 16)*sizeof(Elf32_Shdr));  
							/* pShStrTabHdr points to section header of .shstrtab */
	
	char* pShStrTab = (char*)((unsigned long)elf_hdr + endian(pShStrTabHdr->sh_offset)); /* pShStrTab points to section header string table */
	
	int i;

	for(i=0;i<number; i++)
 	{		

		if( endian(psh[i].sh_type) == SHT_SYMTAB ) 
		{		
			/* dump symbol table  */			
			Elf32_Shdr* pSymTabHdr = &psh[i];								/* points to SYMBOL header in question		*/ 
			Elf32_Sym* pSymTab = (Elf32_Sym*)((unsigned long)elf_hdr + endian(pSymTabHdr->sh_offset));	/* pSymTab points to Symbol Table */
			unsigned int nentries = endian(pSymTabHdr->sh_size) / sizeof(Elf32_Sym);			/* number of symbol table entries to process 	*/
								
			printf("   Num:       Value   Size   Type        Bind        Vis        Ndx          Name\n");
			
			int n;
			char *pSymName;
			unsigned int strtabindx = endian(pSymTabHdr->sh_link);				/* index of section header that holds the stringtable */
			Elf32_Shdr *pStrTabHdr = &psh[strtabindx];					/* points to StringTable header */
			char* pStrTab = (char*)((unsigned long)elf_hdr + endian(pStrTabHdr->sh_offset));		/* pStrTab points to String Table */

			const char* type,bind;
			
			for(n=0; n<nentries; n++)
			{
			
				// compute which name the symbol has ....
			 	if(endian(pSymTab[n].st_name) == 0)	// if ==0 the symbol name is a section name, look in .shstrtab
			 	{ 	
			 		pSymName = &pShStrTab[endian(psh[n].sh_name)];
			 	} 
			 	else if(pStrTab == NULL)			// otherwise look for the symbol name in the .strtab
			 	{
			 		sprintf(pSymName,"<string table index %3ld>", endian(pSymTab[n].st_name) );   // if not present, print out the index
			 	}
			 	else
			 	{
			 		pSymName = &pStrTab[endian(pSymTab[n].st_name)];			 			
			 	}			 	

				if ( (endian(pSymTab[n].st_shndx << 16) == SHN_UNDEF && n != 0)  ||
				     (endian(pSymTab[n].st_shndx << 16) == SHN_COMMON) 	
				   )		
				{
				    printf(" %5d   0x%08lx  %5ld   %-10s  %-10s  %-10s %-10s   %-20s \n", n, endian(pSymTab[n].st_value), endian(pSymTab[n].st_size) , 
									      get_symbol_type( ELF32_ST_TYPE(pSymTab[n].st_info) ),
									      get_symbol_bind( ELF32_ST_BIND(pSymTab[n].st_info) ),
									      get_symbol_visibility (ELF32_ST_VISIBILITY (pSymTab[n].st_other)),
									      get_symbol_shndx(endian(pSymTab[n].st_shndx << 16)), pSymName   );									      
									      
				}
			}
						
								
		}
	
 	} 
	
}


void print_prg_hdrs(Elf32_Ehdr* elf_hdr)
{
	unsigned int i;
	
	if(elf_hdr== NULL) return;
	
	unsigned long number = endian(((unsigned long)elf_hdr->e_phnum) << 16);
	unsigned long size = endian(((unsigned long)elf_hdr->e_phentsize) << 16);
	unsigned long phoffset = endian(elf_hdr->e_phoff);
	
	Elf32_Phdr *psh = (Elf32_Phdr *) (elf_hdr + phoffset);
	
	if(phoffset == 0)
	{
		printf(" There are no program headers in this file\n\n");
		return;
	}
	
	printf(" There are %ld program segments of size %ld at offset 0x%08lx:\n\n",	number,size,phoffset);
	
	
	return;
	
	
}

static const char *get_section_type_name (unsigned long sh_type)     
{
  static char buff [32];

  switch (sh_type)
    {
    case SHT_NULL:		return "NULL";
    case SHT_PROGBITS:		return "PROGBITS";
    case SHT_SYMTAB:		return "SYMTAB";
    case SHT_STRTAB:		return "STRTAB";
    case SHT_RELA:		return "RELA";
    case SHT_HASH:		return "HASH";
    case SHT_DYNAMIC:		return "DYNAMIC";
    case SHT_NOTE:		return "NOTE";
    case SHT_NOBITS:		return "NOBITS";
    case SHT_REL:		return "REL";
    case SHT_SHLIB:		return "SHLIB";
    case SHT_DYNSYM:		return "DYNSYM";
    case SHT_INIT_ARRAY:	return "INIT_ARRAY";
    case SHT_FINI_ARRAY:	return "FINI_ARRAY";
    case SHT_PREINIT_ARRAY:	return "PREINIT_ARRAY";
    case SHT_GNU_verdef:	return "VERDEF";
    case SHT_GNU_verneed:	return "VERNEED";
    case SHT_GNU_versym:	return "VERSYM";
    case 0x6ffffff0:	        return "VERSYM";
    case 0x6ffffffc:	        return "VERDEF";
    case 0x7ffffffd:		return "AUXILIARY";
    case 0x7fffffff:		return "FILTER";
    default: 			return buff;
    }
}


static const char *get_elf_section_flags (unsigned long sh_flags)
{
  static char buff [32];

  * buff = 0;
  
  while (sh_flags)
    {
      unsigned long flag;

      flag = sh_flags & - sh_flags;
      sh_flags &= ~ flag;
      
      switch (flag)
	{
	case SHF_WRITE:            strcat (buff, "W"); break;
	case SHF_ALLOC:            strcat (buff, "A"); break;
	case SHF_EXECINSTR:        strcat (buff, "X"); break;
	case SHF_MERGE:            strcat (buff, "M"); break;
	case SHF_STRINGS:          strcat (buff, "S"); break;
	case SHF_INFO_LINK:        strcat (buff, "I"); break;
	case SHF_LINK_ORDER:       strcat (buff, "L"); break;
	case SHF_OS_NONCONFORMING: strcat (buff, "O"); break;
	  
	default:
	  if (flag & SHF_MASKOS)
	    {
	      strcat (buff, "o");
	      sh_flags &= ~ SHF_MASKOS;
	    }
	  else if (flag & SHF_MASKPROC)
	    {
	      strcat (buff, "p");
	      sh_flags &= ~ SHF_MASKPROC;
	    }
	  else
	    strcat (buff, "x");
	  break;
	}
    }
  
  return buff;
}

static const char* elf_m68k_reloc_type(unsigned long type)
{
/* Relocation types.  */
	switch(type)
	{		
  		case 0: return "R_68K_NONE";          /* No reloc */
		case 1: return "R_68K_32";            /* Direct 32 bit  */
		case 2: return "R_68K_16";            /* Direct 16 bit  */
		case 3: return "R_68K_8";             /* Direct 8 bit  */
		case 4: return "R_68K_PC32";          /* PC relative 32 bit */
		case 5: return "R_68K_PC16";          /* PC relative 16 bit */
		case 6: return "R_68K_PC8";           /* PC relative 8 bit */
		case 7: return "R_68K_GOT32";         /* 32 bit PC relative GOT entry */
		case 8: return "R_68K_GOT16";         /* 16 bit PC relative GOT entry */
		case 9: return "R_68K_GOT8";          /* 8 bit PC relative GOT entry */
		case 10: return "R_68K_GOT32O";       /* 32 bit GOT offset */
		case 11: return "R_68K_GOT16O";       /* 16 bit GOT offset */
		case 12: return "R_68K_GOT8O";        /* 8 bit GOT offset */
		case 13: return "R_68K_PLT32";        /* 32 bit PC relative PLT address */
		case 14: return "R_68K_PLT16";        /* 16 bit PC relative PLT address */
		case 15: return "R_68K_PLT8";         /* 8 bit PC relative PLT address */
		case 16: return "R_68K_PLT32O";       /* 32 bit PLT offset */
		case 17: return "R_68K_PLT16O";       /* 16 bit PLT offset */
		case 18: return "R_68K_PLT8O";        /* 8 bit PLT offset */
		case 19: return "R_68K_COPY";         /* Copy symbol at runtime */
		case 20: return "R_68K_GLOB_DAT";     /* Create GOT entry */
		case 21: return "R_68K_JMP_SLOT";     /* Create PLT entry */
		case 22: return "R_68K_RELATIVE";     /* Adjust by program base */
 		 /* These are GNU extensions to enable C++ vtable garbage collection.  */
		case 23: return "R_68K_GNU_VTINHERIT";
		case 24: return "R_68K_GNU_VTENTRY";
		case 25: return "R_68K_max";
		default: return "R_68K_UNKNOWN";
	}
}


static const char* get_symbol_type(unsigned long type)
{
/* Legal values for ST_TYPE subfield of st_info (symbol type).  */
	switch(type)
	{		
  		case STT_NOTYPE: return "NOTYPE";    /* Symbol type is unspecified */  
		case STT_OBJECT: return "OBJECT";    /* Symbol is a data object */  
		case STT_FUNC: return "FUNC";        /* Symbol is a code object */ 
		case STT_SECTION: return "SECTION";  /* Symbol associated with a section */     
		case STT_FILE: return "FILE";        /* Symbol's name is file name */
		case STT_COMMON: return "COMMON";    /* Symbol is a common data object */ 
		case STT_NUM: return "NUM";          /* Number of defined types.  */ 		
		case STT_LOOS: return "LOOS";        /* Start of OS-specific */
		case STT_HIOS: return "HIOS";        /* End of OS-specific */
		case STT_LOPROC: return "LOPROC";    /* Start of processor-specific */  
		case STT_HIPROC: return "HIPROC";    /* End of processor-specific */		
		default: return "?";
	}
}



static const char* get_symbol_bind(unsigned long type)
{
/* Legal values for ST_BIND subfield of st_info (symbol binding).  */
	switch(type)
	{		
  		case STB_LOCAL: return "LOCAL";          /* Local symbol */
		case STB_GLOBAL: return "GLOBAL";            /* Global symbol */
		case STB_WEAK: return "WEAK";            /* Weak symbol */
		case STB_NUM: return "NUM";             /* Number of defined types.  */
		case STB_LOOS: return "LOOS";         /* Start of OS-specific */
		case STB_HIOS: return "HIOS";          /* End of OS-specific */
		case STB_LOPROC: return "LOPROC";           /* Start of processor-specific */
		case STB_HIPROC: return "HIPROC";        /* End of processor-specific */
		default: return "?";
	}
}


static const char *
get_symbol_visibility (visibility)
     unsigned int visibility;
{
  switch (visibility)
    {
    case STV_DEFAULT:   return "DEFAULT";
    case STV_INTERNAL:  return "INTERNAL";
    case STV_HIDDEN:    return "HIDDEN";
    case STV_PROTECTED: return "PROTECTED";
    default: abort ();
    }
}



static const char* get_symbol_shndx(unsigned long indx)
{
/* translate special section indices.  */
 static char buff [32];
 
	switch(indx)
	{		
  		case SHN_UNDEF: return "UNDEF";          	/* Undefined section */
		case SHN_LORESERVE: return "LORESERVE";       	/* Start of reserved indices */
		//case SHN_LOPROC: return "LOPROC";        	/* Start of processor-specific */  
		case SHN_HIPROC: return "HIPROC";         	/* End of processor-specific */   
		case SHN_LOOS: return "LOOS";        		/* Start of OS-specific */
		case SHN_HIOS: return "HIOS";         		/* End of OS-specific */
		case SHN_ABS: return "ABS";          		/* Associated symbol is absolute */
		case SHN_COMMON: return "COMMON";      		/* Associated symbol is common */
		case SHN_XINDEX: return "XINDEX";        	/* Index is in extra table.  */
		//case SHN_HIRESERVE: return "HIRESERVE";      	/* End of reserved indices */				
		default: 
			sprintf(buff,"%ld",indx);
			return buff;
	}
}

//--------------------------------------------------------- DEBUG ------------------------------------------------------------------------

void print_sym_table_d(Elf32_Ehdr* elf_hdr)
{

	if(elf_hdr== NULL) return;
	
	printf("\n");
	
	unsigned long number = endian(((unsigned long)elf_hdr->e_shnum) << 16);		/* number of section headers      */
	
	unsigned long size = endian(((unsigned long)elf_hdr->e_shentsize) << 16);	/* size of elf headers (should be equal sizeof(Elf32_Shdr) */
	unsigned long shoffset = endian(elf_hdr->e_shoff);				/* offset to section header table */
	
	Elf32_Shdr *psh = (Elf32_Shdr *) ((unsigned long)elf_hdr+shoffset);		/* points to start of section headers */
	
	/* get section header string table */	
	Elf32_Shdr *pShStrTabHdr = (Elf32_Shdr *)((unsigned long)psh + endian(((unsigned long)elf_hdr->e_shstrndx) << 16)*sizeof(Elf32_Shdr));  
							/* pShStrTabHdr points to section header of .shstrtab */
	
	char* pShStrTab = (char*)((unsigned long)elf_hdr + endian(pShStrTabHdr->sh_offset)); /* pShStrTab points to section header string table */
	
	int i;

	for(i=0;i<number; i++)
 	{		

		if( endian(psh[i].sh_type) == SHT_SYMTAB ) 
		{		
			/* dump symbol table  */			
			Elf32_Shdr* pSymTabHdr = &psh[i];								/* points to SYMBOL header in question		*/ 
			Elf32_Sym* pSymTab = (Elf32_Sym*)((unsigned long)elf_hdr + endian(pSymTabHdr->sh_offset));	/* pSymTab points to Symbol Table */
			unsigned int nentries = endian(pSymTabHdr->sh_size) / sizeof(Elf32_Sym);			/* number of symbol table entries to process 	*/
					
			printf(" Symbol table \' %s \' contains %d  entries:\n",&pShStrTab[endian(pSymTabHdr->sh_name)],nentries);
			printf("   Num:       st_value   st_size   Type(st_info)        Bind(st_info)        Vis(st_other)        Ndx(st_shndx)          st_name\n");
			
			int n;
			char *pSymName;
			unsigned int strtabindx = endian(pSymTabHdr->sh_link);				/* index of section header that holds the stringtable */
			Elf32_Shdr *pStrTabHdr = &psh[strtabindx];					/* points to StringTable header */
			char* pStrTab = (char*)((unsigned long)elf_hdr + endian(pStrTabHdr->sh_offset));		/* pStrTab points to String Table */

			const char* type,bind;
			
			for(n=0; n<nentries; n++)
			{
			
				// compute which name the symbol has ....
			 	if(endian(pSymTab[n].st_name) == 0)	// if ==0 the symbol name is a section name, look in .shstrtab
			 	{ 	
			 		pSymName = &pShStrTab[endian(psh[n].sh_name)];
			 	} 
			 	else if(pStrTab == NULL)			// otherwise look for the symbol name in the .strtab
			 	{
			 		sprintf(pSymName,"<string table index %3ld>", endian(pSymTab[n].st_name) );   // if not present, print out the index
			 	}
			 	else
			 	{
			 		pSymName = &pStrTab[endian(pSymTab[n].st_name)];			 			
			 	}			 	

				printf(" %5d        0x%08lx   %5ld   %-10s           %-10s           %-10s           %-10s             0x%08lx \n", n, endian(pSymTab[n].st_value), endian(pSymTab[n].st_size) , 
									      get_symbol_type( ELF32_ST_TYPE(pSymTab[n].st_info) ),
									      get_symbol_bind( ELF32_ST_BIND(pSymTab[n].st_info) ),
									      get_symbol_visibility (ELF32_ST_VISIBILITY (pSymTab[n].st_other)),
									      get_symbol_shndx(endian(pSymTab[n].st_shndx << 16)), endian(pSymTab[n].st_name)   );
			}
						
								
		}
	
 	} 
	
}


void print_str_table_d(Elf32_Ehdr* elf_hdr)
{
	if(elf_hdr== NULL) return;
	
	printf("\n");
	
	unsigned long number = endian(((unsigned long)elf_hdr->e_shnum) << 16);		/* number of section headers      */
	
	unsigned long size = endian(((unsigned long)elf_hdr->e_shentsize) << 16);	/* size of elf headers (should be equal sizeof(Elf32_Shdr) */
	unsigned long shoffset = endian(elf_hdr->e_shoff);				/* offset to section header table */
	
	Elf32_Shdr *psh = (Elf32_Shdr *) ((unsigned long)elf_hdr+shoffset);		/* points to start of section headers */
	
	/* get section header string table */	
	Elf32_Shdr *pShStrTabHdr = (Elf32_Shdr *)((unsigned long)psh + endian(((unsigned long)elf_hdr->e_shstrndx) << 16)*sizeof(Elf32_Shdr));  
							/* pShStrTabHdr points to section header of .shstrtab */
	
	char* pShStrTab = (char*)((unsigned long)elf_hdr + endian(pShStrTabHdr->sh_offset)); /* pShStrTab points to section header string table */
	
	int i;

	for(i=0;i<number; i++)
 	{		

		if( endian(psh[i].sh_type) == SHT_STRTAB ) 
		{
			char* pStrTab = (char *)((unsigned long)elf_hdr+endian(psh[i].sh_offset));
			
			printf("\n String table  \' %s \' at offset 0x%08lx contains %ld bytes:\n",&pShStrTab[endian(psh[i].sh_name)], endian(psh[i].sh_offset), endian(psh[i].sh_size));
			
			//printf("Name = %s , Offsett = 0x%08lx, Length = 0x%08lx\n",&pShStrTab[endian(psh[i].sh_name)],endian(psh[i].sh_offset),endian(psh[i].sh_size));
			dump_data(pStrTab, (unsigned int)endian(psh[i].sh_size));
		}
	}
}


void print_reloc_table_d(Elf32_Ehdr* elf_hdr)
{
		
	if(elf_hdr== NULL) return;	
	
	unsigned int i,ii;
	unsigned long type,offset,value,symval,shindx,symindx,stindx,addend;
	
	unsigned long number = endian(((unsigned long)elf_hdr->e_shnum) << 16);		// number of section headers      	
	unsigned long shoffset = endian(elf_hdr->e_shoff);				// offset to section header table 
	
	Elf32_Shdr *psh = (Elf32_Shdr *) ((unsigned long)elf_hdr+shoffset);	
	Elf32_Shdr *pRelaHdr = psh;		
	
	// get section header string table 	
	Elf32_Shdr *pShStrTabHdr = (Elf32_Shdr *)((unsigned long)psh + endian(((unsigned long)elf_hdr->e_shstrndx) << 16)*sizeof(Elf32_Shdr));  
							// pShStrTabHdr points to section header of .shstrtab 
	char* pShStrTab = (char*)((unsigned long)elf_hdr + endian(pShStrTabHdr->sh_offset)); // pShStrTab points to section header string table 
	Elf32_Rela *relas;
	
	
	char *pSymName;
	
	printf("\n");
	
	
	for(i=0;i<number; i++,pRelaHdr++)
	{
		
		if( endian(pRelaHdr->sh_type) == SHT_RELA ) // used in m68k systems (addendum in relocation table) 
		{
			/*
			case SHT_RELA: do_rela(elf_hdr, i, SHT_RELA, loadaddr); break;  // used in m68k systems (addendum in relocation table) 	
			case SHT_REL : do_rela(elf_hdr, i, SHT_REL, loadaddr); break;   // used in IA32 systems (addendum at relocation) 
			*/
			
			const char  *rtype;
			
												// points to RELA header in question 
			
			unsigned int nrelas = endian(pRelaHdr->sh_size) / sizeof(Elf32_Rela);				// number of relocations to process 
			Elf32_Rela * pRelocTab = (Elf32_Rela * )((unsigned long)elf_hdr + endian(pRelaHdr->sh_offset)); // pRelocTab points to relocation table 
			
			unsigned int symtabindx = endian(pRelaHdr->sh_link);						// index of section header that holds the relevant symboltable 	
			Elf32_Shdr *pSymTabHdr = &psh[symtabindx];							// points to SymbolTable header 
			Elf32_Sym* pSymTab = (Elf32_Sym*)((unsigned long)elf_hdr + endian(pSymTabHdr->sh_offset));	// pSymTab points to Symbol Table 
			
			unsigned int strtabindx = endian(pSymTabHdr->sh_link);						// index of section header that holds the stringtable 
			Elf32_Shdr *pStrTabHdr = &psh[strtabindx];							// points to StringTable header 
			char* pStrTab = (char*)((unsigned long)elf_hdr + endian(pStrTabHdr->sh_offset));		// pStrTab points to String Table 
	
			
			printf(" Relocation section [%d] \' %s \' at offset 0x%08lx contains %d entries:\n", i, &pShStrTab[endian(pRelaHdr->sh_name)] , 
														endian(pRelaHdr->sh_offset), nrelas); 
	 		printf(" Offset      Info         Type            Symbol's Value   Symbol's Name       (st_name)      Binding      Addend\n");
	 		
	 		
	 		for(ii=0,relas = pRelocTab; ii< nrelas; ii++,relas++)
			 {
			 	offset = endian(relas->r_offset);
			 	type = ELF32_R_TYPE(endian(relas->r_info));
			 	shindx = ELF32_R_SYM (endian(relas->r_info)); // section header index, point to section header which in turn points to ShStrTab via index sh_name
			 	symval = endian(pSymTab[shindx].st_value); 
			 	
			 	
			 	// compute which name the symbol has ....
			 	if(endian(pSymTab[shindx].st_name) == 0)	// if ==0 the symbol name is a section name, look in .shstrtab
			 	{ 	
			 		pSymName = &pShStrTab[endian(psh[shindx].sh_name)];
			 	} 
			 	else if(pStrTab == NULL)			// otherwise look for the symbol name in the .strtab
			 	{
			 		sprintf(pSymName,"<string table index %3ld>", endian(pSymTab[shindx].st_name) );   // if not present, print out the index
			 	}
			 	else
			 	{
			 		pSymName = &pStrTab[endian(pSymTab[shindx].st_name)];	
			 	}
			 	
			 	addend = endian(relas->r_addend);
			 	
			 	switch (endian(((unsigned long)elf_hdr->e_machine) << 16))
			 	{
			 		case EM_68K:
				  		rtype = elf_m68k_reloc_type (type);	  		
				  		break;
					default: rtype = "NON 68K Type";
			 	}
			 
			 	printf(" 0x%08lx  0x%08lx   %-19s 0x%08lx   %-20s(0x%08lx)    %-10s  +%ld\n",
			 		offset, 						// Offset 			
			 		type, 							// Info   			
			 		rtype,							// R-Type   			
			 		symval,							// SymValue  			
			 		pSymName,						// SymName  
			 		endian(pSymTab[shindx].st_name),			// name index 		
			 		get_symbol_bind( ELF32_ST_BIND(pSymTab[shindx].st_info) ), // Binding
			 		addend);						// Addendum 			
			 }
			 printf("\n");
			 printf(" Program will be loaded at 0x%08lx\n\n",loadaddr);
					
		}else if( endian(psh->sh_type) == SHT_REL ) // used in IA32 systems (addendum at relocation)
		{
			printf(" IA32 relocation \n");
		}
		else
		{ // not a relocation header
		}
	}
	
}	

void debug_out(Elf32_Ehdr* hdr)
{
	print_elf_hdr(hdr);
	print_sec_hdrs(hdr);
	//-------- print headers plain ------
	print_prg_hdrs(hdr);	
	//print_sym_table(hdr);
	
	print_reloc_table_d(hdr);
	
	print_sym_table_d(hdr);	
	
	print_str_table_d(hdr);
	
	
	CleanUp();
	exit(0);
}

