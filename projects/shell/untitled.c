extern char   __CLIB_BUILD_DATE;
extern char   __CLIB_BUILD_NUMBER;
extern unsigned long   _CLIB_BUILD_DATE;
extern unsigned long   _CLIB_BUILD_NUMBER;

static BYTE sd_buffer[2*SD_BLOCKSIZE];

int cmd_test(char* args)
{
  DRESULT res;
  DSTATUS sta;
  union csd_reg csd;
  struct cid_reg cid;
  struct _sddriveinfo di;
  BYTE *bp;
  unsigned int capacity, nsectors, sector, bpb, BLOCKNR, BLOCK_LEN, MULT;
  //struct csd_reg_v1_0 csd;
  unsigned int i,j;
  DWORD addr;
  char c;
  struct _dev dev;

  printf(" TEST....\n");

  if(sd_init(0) == NULL){
  	printf(" sd_init failed ...\n");
  	return 0;
  }

 
  sta = sd_rd_csd(0, &csd);

  switch(csd.v10.CSD_STRUCTURE){
  	case 0:  // CSD Version 1.0: Version 1.01-1.10/Version 2.00/Standard Capacity 
	  printf(" CSD_STRUCTURE    = %d\n", csd.v10.CSD_STRUCTURE);
	  printf(" SECTOR_SIZE      = %d\n", csd.v10.SECTOR_SIZE);
	  printf(" C_SIZE           = %d\n", csd.v10.C_SIZE);
	  printf(" C_SIZE_MULT      = %d\n", csd.v10.C_SIZE_MULT);
	  printf(" READ_BL_LEN      = %d\n", csd.v10.READ_BL_LEN);
	  printf(" READ_BL_PARTIAL  = %d\n", csd.v10.READ_BL_PARTIAL);
	  printf(" WRITE_BL_LEN     = %d\n", csd.v10.WRITE_BL_LEN);
	  printf(" WRITE_BL_PARTIAL = %d\n", csd.v10.WRITE_BL_PARTIAL);
	  printf(" FILE_FORMAT_GRP  = %d\n", csd.v10.FILE_FORMAT_GRP);
	  printf(" FILE_FORMAT      = %d\n", csd.v10.FILE_FORMAT);
	  printf(" CRC              = %d\n", csd.v10.CRC);
	  printf(" ====>\n");

	  bpb = 2 << (csd.v10.READ_BL_LEN -1);
	  MULT = 2 << (csd.v10.C_SIZE_MULT+1);
	  BLOCKNR = MULT * (csd.v10.C_SIZE +1);
	  BLOCK_LEN = 2 << (csd.v10.READ_BL_LEN -1);
	  capacity = BLOCKNR * BLOCK_LEN ;
	  nsectors = BLOCKNR;
	  printf(" nsectors         = %d\n",BLOCKNR);
	  printf(" Capacity (MB)    = %d\n",capacity/(1024*1024));


	  break;   
	case 1:  // SDHC-Card: CSD Version 2.0: Version 2.00-High Capacity	
	  printf(" CSD_STRUCTURE    = %d\n", csd.v20.CSD_STRUCTURE);
	  printf(" SECTOR_SIZE      = %d\n", csd.v20.SECTOR_SIZE);
	  printf(" C_SIZE           = %d\n", csd.v20.C_SIZE);
	  printf(" READ_BL_LEN      = %d\n", csd.v20.READ_BL_LEN);
	  printf(" READ_BL_PARTIAL  = %d\n", csd.v20.READ_BL_PARTIAL);	  
	  printf(" WRITE_BL_LEN     = %d\n", csd.v20.WRITE_BL_LEN);
	  printf(" WRITE_BL_PARTIAL = %d\n", csd.v20.WRITE_BL_PARTIAL);
	  printf(" CRC              = %d\n", csd.v20.CRC);
	  printf(" ====>\n");
	  nsectors = (csd.v20.C_SIZE + 1);
	  capacity = nsectors * 512 ;
	  printf(" nsectors         = %d\n",nsectors);
	  printf(" Capacity (GB)    = %d\n",capacity/(1024*1024));
	  break;
	case 2: // MMC ?
	   printf(" this is maybe a MMC card ...");
	   break;
	default: // reserved
	   printf(" this is an unknown sd card, CSD_STRUCTURE = %d\n",csd.v10.CSD_STRUCTURE);   	  
	}





  sta = sd_rd_cid(0, &cid);

  printf(" MID              = %d\n", cid.MID);
  printf(" OID              = %c%c\n", cid.OID[0],cid.OID[1]);
  printf(" PNM              = %c%c%c%c%c\n", cid.PNM[0],cid.PNM[1],cid.PNM[2],cid.PNM[3],cid.PNM[4]);
  printf(" PRV              = %d\n", cid.PRV);
  printf(" PSN              = %u\n", cid.PSN);
  printf(" MDT              = %d\n", cid.MDT);
  printf(" CRC              = %d\n", cid.CRC);
 

printf(" Random Read/Write to/from SD Card..."); getchar(); printf("\n"); 

i=0;
dev.pdrv = 0;
c=0;
while(c != 'e'){
	sector = rand() % (nsectors-3);	/* sector = 0...nsectors-3 (we like to read 2 sectors at once)  */
    if((res=sd_read  ( &dev, sd_buffer, sector, 2 )) != RES_OK)
    {
    	printf("error %d reading sector %d-%d (%d)\n",res,sector,sector+1,i);
    	c=getchar();
    }

    sector = rand() % (nsectors-3);	/* sector = 0...nsectors-2 */
    if((res=sd_write  ( &dev, sd_buffer, sector, 2 )) != RES_OK)
    {
    	printf("error %d writing sector %d-%d (%d)\n",res,sector,sector+1,i);
    	c=getchar();
    }
    printf("."); i++;
}
// for(i=0; i<2*SD_BLOCKSIZE;i++) sd_buffer[i]=i;


// dev.pdrv = 0;
// for(i=0; i<1000; i+=2){
// 	  sd_read  ( &dev, sd_buffer, i+1000, 2 );
//     sd_write ( &dev, sd_buffer, i, 2 );
// }
  

  memset(sd_buffer,0xaa,2*SD_BLOCKSIZE);
  
//  sd_write_nblock (0, 3, 2, sd_buffer);
//  sd_write_nblock (0, 5, 2, sd_buffer);


  printf(" Read SD Card..."); getchar(); printf("\n");

  addr=0x3c00;
  do{

  	sd_read_nblock (0, addr, 2, sd_buffer);

  	i=0;
  	while(i<2*SD_BLOCKSIZE)
  	{
  		printf("%02X",sd_buffer[i]);
  		i++;
  	}
  	c=getchar();
  	addr++;
  	addr++;
  }while(c != 'e');

  return 0;



  printf("Build date  : %u\n", (unsigned long) &__BUILD_DATE - (unsigned long) &_start);
  printf("Build number: %u\n", (unsigned long) &__BUILD_NUMBER - (unsigned long) &_start);
  
  printf("CLib build date  : %u\n", (unsigned long) &__CLIB_BUILD_DATE - (unsigned long) &_start);
  printf("CLib build number: %u\n", (unsigned long) &__CLIB_BUILD_NUMBER - (unsigned long) &_start);
  
  printf("CLib build date  : %u\n", (unsigned long) _CLIB_BUILD_DATE);
  printf("CLib build number: %u\n", (unsigned long) _CLIB_BUILD_NUMBER);
  
  printf("FATFS version    : %s\n", FAT_FS_VERSION);
  /*
   * 
   * Note that linker symbols are not variables, they have no memory allocated for maintaining a value, rather their address is their value. 
   * 
   */ 
  
  return 0;
  // test function
 void *mem[100],*p; // array of memory
 
 printf(" strlen(\"%s\") = %d\n",args,strlen(args));
 
 return 0;

  printf(" Start MALLOC Test: (KEY)"); getchar(); printf("\n\n");

  mem[0] = malloc(10000);  // 0x02710
  mem[1] = malloc(500);	 // 0x001F4
  mem[2] = malloc(200000); // 0x30D40
  mem[3] = malloc(10);	 // 0xA
  mem[4] = malloc(100);	 // 0x64
  mem[5] = malloc(500000); // 0x7A120
  
  walk_heap(); getchar();
  
  free(mem[1]); 
  free(mem[3]);
  free(mem[4]);
  
  walk_heap(); getchar();
  
  mem[1] = malloc(450);
  
  walk_heap(); getchar();
  
  mem[3] = malloc(105);
  
  walk_heap(); getchar();
  
  free(mem[2]);
  
  walk_heap(); getchar();
  
  mem[2] = malloc(200010);
    
  walk_heap(); getchar();
  
  mem[4] = malloc(200010);
    
  walk_heap(); getchar();
  
  free(mem[0]);
  free(mem[1]);
  free(mem[2]);
  free(mem[3]);
  free(mem[4]);
  free(mem[5]);
  
  walk_heap(); getchar();
  
  printf("Ready !\n");

  
  return 0;
}