Um eine SD-Card zu erstellen, die auf dem NKC booten kann und gleichzeitig von WinXP aus über USB beschreibbar ist muss man etwas tricksen:

- zum editieren der SDCard muss mit HxD zunächst das Medium geöffnet werden (Wechseldatenträger xy). Wenn man das
 (DOS) Laufwerk öffnet, sieht man nur die Partition, also Wechseldatenträger ab Sektor 66 !!
- Es wird eine FAT16 Struktur mit Partitionstabelle benötigt.
- Mit WinXP kan man aber keine Partitionen auf einer SD-Card erstellen
- Der LDR_PRT1.BIN wird nach Sektor 0 kopiert.
- Windows sieht jetzt eine nicht formatierte SD-Card
- Die wird formatiert (FAT16), WinXP beachtet dabei die Partitionstabelle und schreibt den Windows Boot Record sauber in den Sektor 66 
  (wie in der Tabelle vorgegeben)
- Den LDR_PRT2.BIN kopiert man in den Sektor 1
- Unter Windows kann man jetzt Dateien in die erstellte Partition kopieren

- der NKC Bootet jetzt LDR1, dieser läd wiederum LDR2 welcher seinerseits NKC68k.rom läd und startet.

- Für die ROM-Version des Kernels läd LDR2 NKC68K.rom nach 0x100000
  crt0_rom.S kopiert dann Daten, BSS und romfs nachbelieben und startet dann den Kernel

- Für die RAM-Version wird NKC68K.rom nach 0x400 geladen und dort gestartet
  crt0_ram.S muss dann das ROM-FS (sofern verwendet) verschieben, das BSS Segment initialisieren 
  und den Kernel starten.
  
Erst die RAM Version bietet alle Möglichkeiten, da der Speicher jetzt besser erweitert werden kann !!


Voilá !



UNter Linux ganz einfach :-)

Achtung: Volume darf nicht ge-mounted sein !

MBR schreiben:
sudo dd if=mbr.68k of=/dev/sdb bs=512 count=1


Loader Part 2 ab Sector 1
sudo dd if=ldr.68k of=/dev/sdb bs=512 seek=1


FAT16 Dateisystem in Partition 1 erzeugen:
sudo mkfs.fat /dev/sdb1

Ab Sector 66 steht jetzt die eigentliche Partition....


