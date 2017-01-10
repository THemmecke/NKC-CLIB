#include <debug.h>



#define ULONG unsigned 


void gp_write(char* msg);
void gp_write_hex2(unsigned char val);
void gp_write_hex8(unsigned int val);




void *_ll_malloc(unsigned size);
void _ll_free(void *block);
void _ll_transfer(void);
void mm_init(void);


extern void* _RAM_TOP;
extern void* _HEAP;

int _ram_size;


struct block_header{
			ULONG start;	// block start
			ULONG size;	// block size
			void *next;	// next memory block in chain
			ULONG free;	//for allocated or not (0 if allocated)					
};



static void dbg_walk_heap(void);



void *_ll_malloc(ULONG size)
{
	/* implement 1st fit strategie */		
	
	struct block_header *location = (struct block_header*)_HEAP,*next;
		
	mm_lldbghex(" _ll_malloc: requested block size = 0x",size);
	
	while (location != 0)
	{
		if((location->free == 1) && location->size >= (size + (ULONG)sizeof(struct block_header))) break; // we found a large enough free memory location 
		location = location->next;
	}
	
	if(location == 0) 
	{  
		mm_lldbg(" _ll_malloc: error, no more memory\n");
#ifdef CONFIG_DEBUG_MM
		dbg_walk_heap();
#endif
		return 0; // error, no memory left
	}
	
	mm_lldbg(" _ll_malloc: found free block:\n");
	mm_lldbghex("    START = 0x",location->start);
	mm_lldbghex("    SIZE  = 0x",location->size);
	mm_lldbghex("    NEXT  = 0x",location->next);
	/* shrink memory region, calculate new free region */
	
	next = (struct block_header*)((ULONG)location + (ULONG)size + (ULONG)sizeof(struct block_header));		  	/* calculate start of free block */
		
	next->start = (ULONG)((ULONG)next + (ULONG)sizeof(struct block_header));		  	/* calculate start of user memory */
	next->size = location->size - (ULONG)size - (ULONG)sizeof(struct block_header); 	/* calculate size of free block */
	next->next = location->next;						/* copy link to next block      */
	next->free = 1;								/* mark region as free      	*/
	
	
	location->next = next;							/* link new allocated region to new block */
	location->free = 0;							/* mark region as allocated               */
	location->size = size;							/* store size of region */

	if(location->start == 0)
	{
	    mm_lldbg(" _ll_malloc: location->start = 0x0 !\n");
#ifdef CONFIG_DEBUG_MM
	    dbg_walk_heap();
#endif
	}
		
	return (void*)location->start;
	
}

                               
void _ll_free(void *block)
{
	struct block_header *location = (struct block_header*)_HEAP,*prev,*next;
	
	mm_lldbghex(" _ll_free: block at 0x",block);
	
	prev = next = 0;
	
	while (location != 0)
	{
		if(location->start == (ULONG)block) break; // we found the memory block
		prev = location;
		location = location->next;				
	}
	
	if(location == 0) 
	{		
		mm_lldbg(" _ll_free: block not found.\n");
		return; // we didn't found the location
	}
	
	mm_lldbg(" _ll_free: block found, marking as free.\n");
	
	mm_lldbghex("    START = 0x",location->start);
	mm_lldbghex("    SIZE  = 0x",location->size);
	mm_lldbghex("    NEXT  = 0x",location->next);
	
	location->free = 1; 	// mark location free
	next = location->next;
	
	
	/* now check if we can merge free blocks */
	
	if(prev != 0 && prev->free == 1) /* merge previous free block */
	{
		prev->next = location->next;
		
		mm_lldbghex(" _ll_free: previous block size = 0x",prev->size);
		mm_lldbghex(" _ll_free: current block size  = 0x",location->size);
		prev->size += location->size + (ULONG)sizeof(struct block_header);
		
		mm_lldbghex(" _ll_free: new block size  = 0x",prev->size);
		
		location = prev;
		
		mm_lldbg(" _ll_free: block merged with previous block.\n");
	}
	
	if(next != 0 && next->free == 1)  /* merge next free block */
	{
		location->next = next->next;
		
		mm_lldbghex(" _ll_free: current block size  = 0x",location->size);
		mm_lldbghex(" _ll_free: next block size = 0x",next->size);
		
		location->size += next->size + (ULONG)sizeof(struct block_header);
		
		mm_lldbghex(" _ll_free: new block size  = 0x",location->size);
		
		mm_lldbg(" _ll_free: block merged with following block.\n");
	}
	
#ifdef CONFIG_DEBUG_MM
	dbg_walk_heap();
#endif
	    
}

void _ll_transfer(void)
{
}


void mm_init(void)
{
	_ram_size 	= _RAM_TOP - _HEAP;
	
	mm_lldbg("mm_init\n");
	mm_lldbghex(" _RAM_TOP = 0x",_RAM_TOP);
	mm_lldbghex(" _HEAP = 0x",_HEAP);
	mm_lldbghex(" _ram_size = 0x",_ram_size);
	
	((struct block_header*)_HEAP)->start = (ULONG)(_HEAP + (ULONG)sizeof(struct block_header));
	((struct block_header*)_HEAP)->size = _ram_size - (ULONG)sizeof(struct block_header);
	((struct block_header*)_HEAP)->next = 0;
	((struct block_header*)_HEAP)->free = 1;

		
	#ifdef CONFIG_DEBUG_MM
	dbg_walk_heap();
	#endif
}

void mm_free(void)
{
	mm_lldbg("mm_free...\n");
	mm_init();
}


void dbg_walk_heap(void)
{
	struct block_header *location = (struct block_header*)_HEAP;
	int i = 0;
	int j = 0;

	mm_lldbg("\n memory map: \n\n");
	
	//mm_lldbg(" Block No.     Start          Size         Free        Next Hdr\n\n");
	
	while(location != 0)
	{
	  while(location != 0 && i < 5)
	  {
		mm_lldbghex(" BLOCK-NR = 0x",j);
		mm_lldbghex("    FREE  = 0x",location->free);
		mm_lldbghex("    START = 0x",location->start);
		mm_lldbghex("    SIZE  = 0x",location->size);
		mm_lldbghex("    NEXT  = 0x",location->next);	
		
		location = (struct block_header*)location->next;
		
		i++; j++;
	  };
	  i=0;
	};
		
}

void walk_heap(void)
{
	struct block_header *location = (struct block_header*)_HEAP;
	int i = 0;
	int j = 0;

	gp_write("\n memory map: \n\n");
	
	gp_write(" block  ##     start          size         next hdr      free\n\n");
	
	while(location != 0)
	{
	  while(location != 0 && i < 5)
	  {
		gp_write("      "); gp_write_hex8(j);gp_write("     0x"); gp_write_hex8(location->start);
		gp_write("     0x"); gp_write_hex8(location->size); gp_write("    0x"); 
		gp_write_hex8((ULONG)location->next);
		gp_write("   "); gp_write_hex2(location->free); gp_write("\n");		
		
		location = (struct block_header*)location->next;
		
		i++; j++;
	  };
	  gp_getchar();
	  i=0;
	};
	
	gp_write("\n");	
}

/*
void main(void)
{
	mm_init();
	
	walk_heap();
	
	void *mem1 = _ll_malloc(10);	
	void *mem2 = _ll_malloc(255);
	void *mem3 = _ll_malloc(30);
	void *mem4 = _ll_malloc(5);
	void *mem5 = _ll_malloc(300);
	
	walk_heap();
	
	_ll_free(mem3);	walk_heap();
	_ll_free(mem4);	walk_heap();
	_ll_free(mem2);	walk_heap();
	_ll_free(mem1);	walk_heap();
	_ll_free(mem5);	walk_heap();
	
	
	mm_free();
}
*/
