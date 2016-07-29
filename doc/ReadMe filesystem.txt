startup/startup20.S 
  ->> drvinit		initialize hardware drivers
  ->> fileinit		initialize file systems


initialize file systems:
-----------------------

io/fclose.c
  ->> _ll_init_std()				(nkc/llopen.S)  - setup standard files (stdio, stderr)
  ->> fileinit() ->> _ll_init_fs		(fs/fs.c)	- setup filesystems (FAT,FAT32,JADOS...)


fs/fs.c
  ->> _ll_init_fs ->> nkcfs_init_fs();
		  ->> fatfs_init_fs();
		  
fs/nkc/fs_nkc.c
 ->> nkcfs_init_fs() 
      rregister_driver("JADOSFS",&nkc_file_operations); 
 
fs/fat/fs_fat.c
 ->> fatfs_init_fs()
      register_driver("FAT",&fat_file_operations);
      
      
initialize hardware drivers:
-----------------------
      
      
drivers/drivers.c 
  ->> drvinit()->init_block_device_drivers()
	  hd_initialize()
	  sd_initialize()
	  
drivers/block/hd_block_drv.c
  ->> hd_initialize()
  
drivers/block/sd_block_drv.c
  ->> sd_initialize()


  
filesystem usage:
-----------------

Filesystem and hardware driver must be "connected".
This is accomplished by mounting a filesystem on a hardware device.
For an example look in projects/shell.

A special case yet is the JADOS filesystem:
Access to JADOS drives is done via JADOS/GP calls directly in the JADOS filesystem driver.
Therefore no mounting is needed here, but access is limited to those devices directly supported by JADOS and GP. 









    
