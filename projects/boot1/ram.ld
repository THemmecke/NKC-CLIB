
MEMORY {
	ram    : ORIGIN = 0x000000, LENGTH = 0x1FFFFF
	ram_rs : ORIGIN = 0x000000, LENGTH = 0x1FFFFF
}



SECTIONS {


        .text : {
		_stext = . ;
        	*(.text)
		_etext = ALIGN(0x2) ;
        } > ram

	.data : {
		_sdata = . ;
		*(.data)
		_edata = ALIGN(0x2) ;
	} > ram

	.bss : {
		_sbss = . ;
		*(.bss)
		*(COMMON)
		_ebss = ALIGN(0x2);
	} > ram
        
}

