#include <debug.h>
#include <errno.h>

#include <drivers.h>



struct blk_driver *blk_driverlist = NULL;	/* list of all registered blk device drivers */
struct char_driver *char_driverlist = NULL;	/* list of all registered char device drivers */


/****************************************************************************
 * Private Functions
 ****************************************************************************/

struct blk_driver* get_blk_driver(char *name)
/* name == Device: HD, SD etc. */
{
	struct blk_driver *pdriver;
	char drive_name[10],*p;
	int i;
	
	drv_lldbg("drivers.c|get_blk_driver...\n"); 

	
	if(!name) return NULL; /* no driver found */
	
	i=0;  /* convert drive name to uppercase */
	strcpy(drive_name,name); 				
	while(drive_name[i] && i<3){ drive_name[i] = /*toupper*/(drive_name[i]); i++;}
	
	drive_name[2] = 0; /* only the first two letters matter */
			
	drv_dbg("drivers.c|get_blk_driver: drive_name = %s",drive_name);
	drv_lldbgwait("\n");
		
	// initialize pdriver with driver list
	pdriver = blk_driverlist;
	
	drv_lldbgwait("drivers.c|get_blk_driver: searching for driver in driverlist\n");	
	
	while(pdriver)
	{	
		drv_dbg("drivers.c|get_blk_driver:  next in list = %s\n",pdriver->pdrive);
		drv_lldbgwait("\n");
		
		if(!strcmp(drive_name,pdriver->pdrive) )
		{
			drv_dbg("drivers.c|get_blk_driver:  drive: %s\n",pdriver->pdrive);
			drv_dbg("drivers.c|get_blk_driver:  foper: 0x%x\n",pdriver->blk_oper);
			drv_dbg("drivers.c|get_blk_driver:  open: 0x%x\n",pdriver->blk_oper->open);
			drv_lldbgwait("drivers.c|get_blk_driver: (SUCCESS)... ]\n");
			return pdriver;
		}
		pdriver = pdriver->next;
	}
	
	drv_lldbgwait("drivers.c|get_blk_driver: (FAIL)... ]\n");
	return NULL; /* no driver found */
}
 
 
 /****************************************************************************
 * Name: register_blk_driver
 *
 * Description:
 *   Register a block device driver.
 *
 * Parameters:
 *   	pdrive		- name of device (HD, SD ....)
 *	f_open		- pointer to device operations
 *
 * Return:
 *		EZERO - success   
 *
 ****************************************************************************/
int register_blk_driver(char *pdrive, const struct block_operations  *blk_oper)
{
	struct blk_driver *pdriver, *ptail;
	
	
	drv_lldbg("drivers.c: [ register_driver...\n");
	drv_dbg(" drive: %s\n",pdrive);
	drv_dbg(" foper: 0x%x\n",blk_oper);
	drv_dbg(" open: 0x%x\n",blk_oper->open);
	
	/*
		allocate all buffers
	*/		
	pdriver = (struct blk_driver *)malloc(sizeof(struct blk_driver));
	pdriver->pdrive = (char*)malloc(strlen(pdrive) + 1);
	
	strcpy(pdriver->pdrive, pdrive);
	pdriver->blk_oper = blk_oper;
	pdriver->next = NULL;
			
		
	if(blk_driverlist == NULL)
		blk_driverlist = pdriver;
	else
	{
		ptail = blk_driverlist;
		while(ptail->next) ptail = ptail->next;
		ptail->next = pdriver;
	}			
	
	drv_dbg(" drive: %s\n",pdriver->pdrive);
	drv_dbg(" foper: 0x%x\n",pdriver->blk_oper);
	drv_dbg(" open: 0x%x\n",pdriver->blk_oper->open);
	drv_lldbgwait("....register_driver ]\n");
	
	return EZERO;
}


/****************************************************************************
 * Name: un_register_blk_driver
 *
 * Description:
 *   Un-Register a block device driver.
 *
 * Parameters:
 *   	pdrive		- name of device (HD, SD ....)
 *
 * Return:
 *		EZERO - success   
 *
 ****************************************************************************/
int un_register_blk_driver(char *pdrive)
{
	struct blk_driver *pcur, *plast;
			
	pcur = plast = blk_driverlist;
	
	while(pcur)
	{
		if(!strcmp(pcur->pdrive,pdrive)) 		
		{ // found drive
		  if(pcur == blk_driverlist) 
			blk_driverlist = blk_driverlist->next;
		  else
			plast->next = pcur->next;
			
		  free(pcur->pdrive);
		  free(pcur);
			
		  return EINVDRV; /* Invalid drive specified  */
		}
		
		plast = pcur;
		pcur = pcur->next;
	}		
		
	return EZERO;	
}


/****************************************************************************
 * Name: init_block_device_drivers
 *
 * Description:
 *   Initailize block device drivers.
 *
 * Parameters:
 *   
 *
 * Return:
 *   
 *
 ****************************************************************************/
void init_block_device_drivers(void)  			
{     
#ifdef CONFIG_DRV_XX  
    xx_initialize(); // init device xx
#endif
    
#ifdef CONFIG_DRV_GIDE
    hd_initialize(); // init (G)IDE
#endif

#ifdef CONFIG_DRV_SD    
    sd_initialize(); // initilize SD card
#endif       
    
}

/****************************************************************************
 * Name: init_char_device_drivers
 *
 * Description:
 *   Initailize character device drivers.
 *
 * Parameters:
 *   
 *
 * Return:
 *   
 *
 ****************************************************************************/
void init_char_device_drivers(void)  			
{    
#ifdef CONFIG_DRV_RTC
    rtc_initialize(); // init RTC
#endif 
}


/****************************************************************************
 * Name: drvinit()
 *
 * Description:
 *   Initailize all device drivers.
 *
 * Parameters:
 *   
 *
 * Return:
 *   
 *
 ****************************************************************************/
void drvinit()
{
  int ii;
   
  blk_driverlist = NULL;
 
  
  // initialize block device drivers
  init_block_device_drivers();
  
  // initialize char evice drivers
  init_char_device_drivers();
  // :
  // :
}
