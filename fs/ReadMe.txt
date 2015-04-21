io/fclose.c
  ->> _ll_init_std()				(nkc/llopen.S)  - setup standard files (stdio, stderr)
  ->> fileinit() ->> _ll_init_fs		(fs/fs.c)	- setup filesystems (FAT,FAT32,JADOS...)
  
fs/fs.c
  ->> _ll_init_fs ->> nkcfs_init_fs();
		  ->> fatfs_init_fs();
		  
fs/nkc/fs_nkc.c
 ->> nkcfs_init_fs() 
      register_driver("A","JADOSFS",&nkc_file_operations); 
      register_driver("Q","JADOSFS",&nkc_file_operations);
 
fs/fat/fs_fat.c
 ->> fatfs_init_fs()
      register_driver("hda0","FAT",&fat_file_operations);
      
      

=>

eine Datei A:Hello.txt wird auf LW A, einem Jados FS gesucht
eine Datei HDA0:Hello.txt wird auf LW hda0, einem FAT FS gesucht