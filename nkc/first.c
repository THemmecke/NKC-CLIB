



#define ULONG unsigned 


void nkc_write(char* msg);
void nkc_write_hex2(unsigned char val);
void nkc_write_hex8(unsigned int val);




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







void *_ll_malloc(ULONG size)
{
	/* implement 1st fit strategie */
	
	//nkc_write(" _ll_malloc: ");
	
	struct block_header *location = (struct block_header*)_HEAP,*next;
		
	while (location != 0)
	{
		if((location->free == 1) && location->size >= (size + (ULONG)sizeof(struct block_header))) break; // we found a large enough free memory location 
		location = location->next;
	}
	
	if(location == 0) 
	{  
		//nkc_write(" no more memory left !\n");
		return 0; // error, no memory left
	}
	
	
	/* shrink memory region, calculate new free region */
	
	next = (struct block_header*)((ULONG)location + (ULONG)size + (ULONG)sizeof(struct block_header));		  	/* calculate start of free block */
		
	next->start = (ULONG)((ULONG)next + (ULONG)sizeof(struct block_header));		  	/* calculate start of user memory */
	next->size = location->size - (ULONG)size - (ULONG)sizeof(struct block_header); 	/* calculate size of free block */
	next->next = location->next;						/* copy link to next block      */
	next->free = 1;								/* mark region as free      	*/
	
	
	location->next = next;							/* link new allocated region to new block */
	location->free = 0;							/* mark region as allocated               */
	location->size = size;							/* store size of region */
	
	//nkc_write(" start=0x"); nkc_write_hex8(location->start); nkc_write(" size=0x"); nkc_write_hex8(location->size); nkc_write("\n");
		
	return (void*)location->start;
	
}


void _ll_free(void *block)
{
	struct block_header *location = (struct block_header*)_HEAP,*prev,*next;
	
	//nkc_write("_ll_free: ");
	
	prev = next = 0;
	
	while (location != 0)
	{
		if(location->start == (ULONG)block) break; // we found the memory block
		prev = location;
		location = location->next;
		
		//nkc_write("removed block	");
	}
	
	if(location == 0) 
	{		
		//nkc_write("block not found\n");
		return; // we didn't found the location
	}
	
	
	location->free = 1; 	// mark location free
	next = location->next;
	
	
	/* now check if we can merge free blocks */
	
	if(prev != 0 && prev->free == 1) /* merge previous free block */
	{
		prev->next = location->next;
		prev->size += location->size + sizeof(struct block_header);
		
		location = prev;
	}
	
	if(next != 0 && next->free == 1)  /* merge next free block */
	{
		location->next = next->next;
		location->size += next->size + sizeof(struct block_header);
	}
	
	//nkc_write("\n");
}

void _ll_transfer(void)
{
}


void mm_init(void)
{
	_ram_size 	= _RAM_TOP - _HEAP;
	
	/*
	_heap = malloc(_ram_size); 
	*/
	
	((struct block_header*)_HEAP)->start = (ULONG)(_HEAP + sizeof(struct block_header));
	((struct block_header*)_HEAP)->size = _ram_size - sizeof(struct block_header);
	((struct block_header*)_HEAP)->next = 0;
	((struct block_header*)_HEAP)->free = 1;
	
	/*
	nkc_write(" mm_init: start=0x"); nkc_write_hex8(((struct block_header*)_HEAP)->start);
	nkc_write(", size=0x"); nkc_write_hex8(((struct block_header*)_HEAP)->size); nkc_write("\n");	
	nkc_write(" _HEAP = 0x"); nkc_write_hex8(_HEAP); 
	nkc_write(", sizeof(struct block_header)=0x"); nkc_write_hex8(sizeof(struct block_header)); nkc_write("\n");
	*/
}

void mm_free(void)
{
	mm_init();
}


void walk_heap(void)
{
	struct block_header *location = (struct block_header*)_HEAP;
	int i = 0;
	int j = 0;

	nkc_write("\n Speicherbelegung: \n\n");
	
	nkc_write(" Block No.     Start          Size         Next Hdr      Free\n\n");
	
	while(location != 0)
	{
	  while(location != 0 && i < 5)
	  {
		nkc_write("      "); nkc_write_hex2(j);nkc_write("     0x"); nkc_write_hex8(location->start);
		nkc_write("     0x"); nkc_write_hex8(location->size); nkc_write("    0x"); 
		nkc_write_hex8((ULONG)location->next);
		nkc_write("   "); nkc_write_hex2(location->free); nkc_write("\n");		
		
		location = (struct block_header*)location->next;
		
		i++; j++;
	  };
	  nkc_getchar();
	  i=0;
	};
	
	nkc_write("\n");	
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
