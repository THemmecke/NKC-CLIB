This directory contains a bootloader, that can be used with the sys shell command (/projects/shell).


1) install the bootloader to load the file 'OS.SYS' in current directory. OS.SYS must be contignous on the disk, sys will check this.

 - start the shell (for example with bootloader in project/boot1)
 - if mbr.68k and OS.SYS are located on the first partition of the first IDE hard disk:
   mount hda0 FAT
   hda0:
   dir
   sys hda mbr.68k OS.SYS

2) install to sector 1 after MBR. OS.SYS must fit between MBR and first partition, sys will check this.
  
   sys sda mbr.68k OS.SYS -b

   sys will copy OS.SYS from current directory to sector 1 of first SD card (if it fits).
   sys will modify and merge mbr of sda


  