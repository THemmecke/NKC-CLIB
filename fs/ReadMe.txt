io/fclose.c
  ->> _ll_init_std()				(nkc/llopen.S)  - setup standard files (stdio, stderr)
  ->> fileinit() ->> _ll_init_fs		(fs/fs.c)	- setup filesystems (FAT,FAT32,JADOS...)
  
fs/fs.c
  ->> _ll_init_fs ->> nkcfs_init_fs();
		  ->> fatfs_init_fs();
		  
fs/nkc/fs_nkc.c
 ->> nkcfs_init_fs() 
      register_driver("A","JADOSFS",&nkc_file_operationsonst, &blk_driver); 
      register_driver("Q","JADOSFS",&nkc_file_operations, &blk_driver);
 
fs/fat/fs_fat.c
 ->> fatfs_init_fs()
      register_driver("hda0","FAT",&fat_file_operations, &blk_driver);
      
      
      

=>

eine Datei A:Hello.txt wird auf LW A, einem Jados FS gesucht
eine Datei HDA0:Hello.txt wird auf LW hda0, einem FAT FS gesucht




Intergration der Block Driver:
------------------------------

fs.h:
  struct fs_driver
    struct blk_driver *blk_drv;
    
  struct _file
    struct fs_driver *pfsdrv

    
fs_xxx.c:

Alle Funktionen bekommen einen Zeiger auf struct _file übergeben und haben damit Zugriff auf den File-System-Driver und den Block-Driver.

fs/fat/ff.c

ff.h
  struct FATFS ist der Dreh- und Angelpunkt im FAT Treiber. Dort gibt es einen weiteren Zeiger auf den Block-Treiber des File-Systems:
  FATFS->blk_drv;



    
