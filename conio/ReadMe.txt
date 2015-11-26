Direkter Bildschirmzugriff:
---------------------------

- Framebuffer unterteilt in Sektoren, die als dirty gemarkt werden, wenn auf sie geschrieben wurde.
- In den Framebuffer kann dann bitwise geschrieben werden, die Übertragung erfolgt in den VSync Pausen interruptgesteuert



Benötigte Zeiten / Zeitrahmen:
------------------------------


GDPFPGA-Clk: 40MHz  => T = 25ns
1 Zeile = 1056 Takt-Zyklen
1 Seite = 667 Zeilen
HSYNC alle 1056 * T = 26,4 µs, HSYNC-Länge = 128 * 25ns = 3,2 µs
VSYNC alle 667 * 1056 * T = 176ms, VSYNC-Länge = 4 * 1056 * T = 0,1056 ms


Grösse des Framebuffer:
(x)512 x (y)256 Bildpunkte = 131072 Bildpunkte
1Byte speichert 2 Bildpunkte (Farb-Version)
1 Pixel besteht dabei aus 4 Bit die ein Index in die CLUT sind, damit können 16 (2^4) aus 512 (2^9) Farben gleichzeitig dargestellt werden.
(Die CLUT besteht aus 16 9Bit Einträgen)
1 Seite benötigt damit 64KByte, 4 Seiten 256KByte


Zeit zum Übertragen des Framebuffer 64KByte (68020/20MHz, 16Bit Zugriff):
20MHz == 50ns
25MHz == 40ns

Kalkulation für den 68000:

moveq n,d0
loop:
move.l (Ax)+,(Ay)+		// 20 Zyklen
dbra d0,loop			// 10 Zyklen pro Durchlauf, 14 Zyklen am Ende
=>
Zyklen: 20 * n + 10 * n + 14

Kalkulation für den 68020:


loop:
move.w (Ax)+,(Ay)+		// 7 Zyklen
dbra d0,loop			// 3 Zyklen pro Durchlauf, 7 Zyklen am Ende
=>
64KByte = 64000 Byte = 32000 Word = n
Zyklen: 7 * n + 3 * n + 7 == 320007 => 16ms/20MHz, 12,8ms

