
MEMORY {
	ram    : ORIGIN = 0x000000, LENGTH = 0x1FFFFF
}



SECTIONS {
	
	/* Code */
        .text : {
        	/*. = 0x400;*/ /* standard nkc start address for 68k programs */
        	_start = . ;
		_stext = . ;
		
		/* startup.S needs to be first file */		
		*startup.o(.text)
		
		. = ALIGN(2) ;
        	*(.text)
        	. = ALIGN(2);
		_etext = ALIGN(2) ;
        } > ram =0x4E71 /* set the fill pattern for unspecified regions (due to alignement) to NOP (used by linker)*/

	/* Data */
	.data : {
		. = ALIGN(2) ;
		_sdata = . ;
		*(.data)
		. = ALIGN(2) ;
		*(.rodata)
		. = ALIGN(2) ;
		_edata = ALIGN(2) ;
	} > ram

        /* Debugging Sections */
        
        
        .comment  : { *(.comment) } > ram
        .stab  : { *(.stab) } > ram


	.bss : {
		_sbss = . ;
		*(.bss)
		. = ALIGN(4) ;
		
		/* global variables .comm */
		*(COMMON)
		. = ALIGN(4) ;
		_ebss = ALIGN(0x2);
	} > ram
        
        

}

