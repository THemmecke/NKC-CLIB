Diese Version des Booloaders installiert einen MBR mit Bootloader, der den eigentlichen Lader, der ab Sektor 1 steht, in den Speicher laed und ausfuehrt. Der Lader enthlt die MTools, die eine Datei aus einer FAT16 Partition laden und ausfhren koennen (hier NKC68K.ROM).


Um eine SD-Card zu erstellen, die auf dem NKC booten kann und gleichzeitig von Win* aus über USB beschreibbar ist muss man etwas tricksen:

- zum editieren der SDCard muss mit HxD zunächst das Medium geöffnet werden (Wechseldatenträger xy). Wenn man das
 (DOS) Laufwerk öffnet, sieht man nur die Partition, also Wechseldatenträger ab Sektor 66 (siehe ptable in mbr.S) !!
- Es wird eine FAT16 Struktur mit Partitionstabelle benötigt.
- Mit WinXP kan man aber keine Partitionen auf einer SD-Card erstellen
- Der MBR mbr.68k wird nach Sektor 0 kopiert.
- Windows sieht jetzt eine nicht formatierte SD-Card
- Die wird formatiert (FAT16), Win* beachtet dabei die Partitionstabelle und schreibt den Windows Boot Record sauber in den Sektor 66 
  (wie in der Tabelle vorgegeben)
- Den Loader ldr.68k kopiert man in den Sektor 1
- Unter Windows kann man jetzt Dateien in die erstellte Partition kopieren

- der NKC Bootet jetzt mbr.68k, dieser läd wiederum ldr.68k welcher seinerseits NKC68K.ROM (fname am Ende von ldr.S) läd und startet.



Unter Linux ganz einfach :-)

Achtung: Volume darf nicht ge-mounted sein !

MBR schreiben:
sudo dd if=mbr.68k of=/dev/sdb bs=512 count=1

Loader Part 2 ab Sector 1
sudo dd if=ldr.68k of=/dev/sdb bs=512 seek=1


FAT16 Dateisystem in Partition 1 erzeugen:
sudo mkfs.fat /dev/sdb1

Ab Sector 66 steht jetzt die eigentliche Partition....


