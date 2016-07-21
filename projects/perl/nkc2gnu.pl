#!/usr/bin/perl -w

# known bugs:
#
# ==> fix me    Stellen m..ssen verbessert werden !!
#
# Backslashes m..ssen escaped werden, z.B. '\' => '\\'
# wenn ein Kommetar ohne Leerzeichen folgt wird das nicht immer erkannt (siehe Unten)
# beim Substituieren pc=>%pc wird zb auch pcstand zu %pcstand
# .space .skip und .fill arbeiten nicht so wie gewollt -> z.B. am Ende von grafgdpc.S zum Auff..llen mit 0xFF
# AS mag das Konstrukt 'move 08(%a1),08(%a0) nicht mit führenden Nullen, ebenso bei 'move.l #0800,%d1' !
#
# GNU AS specials:
#
# .equ VARIABLE, 8
# addq.l #VARIABLE, %fp     geht nicht
# addg.l #8, %fp            geht       ---> warum ?
#
# GP AS specials:
#
# Im GP Assembler gibt es moveq.l, der Standard kennt nur moveq ohne Options




# Aufruf: nkc2gnu ASSTEXTE.TXT

#use strict;

print "NKC-ASS to GNU-AS syntax converter v160112     (C) 2016 Torsten Hemmecke\n\n";


# Antwortdatei öffnen
if($ARGV[0]){
 $inputfile = $ARGV[0];
}else
{
 print "usage: nkc2gnu [Antwortdatei]\n\n";
 exit 0;
}



open(DATEI,$inputfile) || die "Fehler ...\n";

# Alle Dateien aus der Antwortdatei abarbeiten...
while(defined($src=<DATEI>) && ($src =~ /\w./)){

#remove return character(s)
chomp($src); 

# Zieldatei basteln:
#   - nur kleine Buchstaben
#   - Endung .asm oder .a in .S für GNU AS wandeln
$dst = $src;
$dst =~ tr/[A-Z]/[a-z]/;        # translation (each character) 
$dstglb = $dst;		        # dstglb soll alle Labels enhalten, die als .global angegeben werden
$dst =~ s/\.['asm'|'a']/\.S/i;   # substitution (words or strings)
$dstglb =~ s/\.['asm'|'a']/\.global/i;   # substitution (words or strings)

$dst =~ /(\w+\.S)/i;	  # Pfadangaben entfernen
$dst = $1;

$dstglb =~ /(\w+\.global)/i;
$dstglb = $1;


$src =~ s/[\n\r]//;
$dst =~ s/[\n\r]//;
$dstglb =~ s/[\n\r]//;

open(SRC,$src) || die "Fehler beim Öffnen der Quelldatei: $src\n";
open(DST,">$dst") || die "Fehler beim Öffnen der Zieldatei: $dst\n";
open(DSTGLB,">$dstglb") || die "Fehler beim Öffnen der Zieldatei: $dstglb\n"; # printf " $dstglb ge..ffnet\n";



printf " converting: $src to $dst ...\n";

print DST ".text\n\n";
print DST "#include \"$dstglb\"\n";	# Global Definitionen einbinden

$rswarned = "FALSE";

while(defined($var=<SRC>)){


# JADOS Datei-Ende ?
if($var =~ /\x00/)  {
        printf " < detected JADOS EOF !! >\n";
        goto END;
}

if($var =~ /\w/){

chomp($var);
$label = "";
$rest = "";
$command = "";
$comment = "";



# Label extrahieren
$var =~ s/^(\s*\w*:)//;
$label = $1 if($1);
$rest = $var if($var);

#print "label = $label\n";

#($label,$rest) = split(/:/,$var);

# Falls kein Label, dann entsprechend anpassen
if(!$rest){
 $rest = $label;
 $label = "";
}

if(defined $rest) {
# Register-Syntax
$rest =~ s/([\s*(),\-\+\/])(a|A|d|D)([0-7])/$1%$2$3/g;

# StackPointer, FramePointer und PC
$rest =~ s/%[a|A]7/%sp/g;
$rest =~ s/%[a|A]6/%fp/g;
#$rest =~ s/pc/%pc/g;
if( $rest =~ /[\s*(),\+\-]pc[\s*(),\+\-]/){$rest=~s/\bpc\b/%pc/;}
if( $rest =~ /[\s*(),\+\-]usp[\s*(),\+\-]/){$rest=~s/\busp\b/%usp/;}
if( $rest =~ /[\s*(),\+\-]sr[\s*(),\+\-]/){$rest=~s/\bsr\b/%sr/;}

# Specialcharacter * = aktueller PC Stand ist in GNU ein .
$rest =~ s/\*(\+|-)/\.$1/;

# Binärzahlen
$rest =~ s/\%([0-1]+)/0b$1/g;
# Hexadezimalzahlen
$rest =~ s/\$([0-9,a-f,A-F]+)/0x$1/g;

# leading Zeros in Integers:
 # 1) bei Konstanten, z.B. #0089
 $rest =~ s/([\s|\,]+#)0+([1-9]+[0-9]*)([\s|\,])/$1$2$3/g;
 # 2) als Offsets, z.B. 08(%a0) o.ä.
 $rest =~ s/([\s|\,]+)0+([1-9]+[0-9]*)(\()/$1$2$3/g;


# Kommando und Kommentar trennen
$rest =~ s/^\*/ \*/;			# am Zeilenanfang Leerzeichen einfügen
$rest =~ s/\(\*/\( \*/;			# taucht im Quelltext haeufiger mal auf (nach öffnender oder 
$rest =~ s/\)\*/\) \*/;			# ...schliessender Klammer) -> Leerzeichen einfügen

$command = " ";

if($rest =~ /(.*)('(.*)\*(.*)')(.*)(\*(.+))?/){ # falls in einem String ein * auftaucht -> Sonderbehandlung...
#
# label ' Dies ist ein String mit *',10,12  * und das ein Kommentar
# $1 = label 
# $2 = ' Dies ist ein String mit *'
# $5 = ,10,12  
# $6 = * und das ein Kommentar
#
  if($1) {$command .= "$1";}
  if($2) {$command .= "$2";}
  if($5) {$command .= "$5";}
  if($6) {$comment .= "$6";}    

}else
{

  ($command,$comment)=split(/[ |\t]\*/,$rest,2);
}

if(defined $comment) { 
    #chomp($comment);
    $comment =~ s/\r|\n//g;    
}

my $res = "";
my $newline = 1;
my $instring = 0; 


# Byte,Word oder Long Definitionen (dc.x)
if($command =~ /[d|D][c|C]\.([b|w|l|B|W|L])/){        # Zeile enthählt Byte,Word oder Long-Definitionen
 $type = $1;
 $command =~s/[d|D][c|C].[b|w|l|B|W|L]//;   	# dc.x entfernen

 $command =~ s/"/\\"/g;		# escape quotas
 
 #chomp($command);
 $command =~ s/\r|\n//g; 
 @vals = split(/,/,$command);   # Bytes extrahieren

 foreach(@vals){
 
  if($instring == 1) { # alle vals müssen in den String bis das abschliessende Hochkomma kommt
    if($_=~ /([^']*)\'/ ){ # String zu Ende ?
        $res .= ",$1\"\n"; # ja, anhängen mit " abschlilessen und NewLine
        $instring = 0;
        $newline = 1;       
    }
    else {  # nein, einfach anhängen
        $res .= ",$_";
    }
  }elsif( $_=~ /\'([^']*)\'/ ){	# enthält einen String (ohne Kommas)
  
    	$res .= "\n   .ascii \"$1\"    \n";# in eine eigene neue Zeile
	$newline = 1; 
	
  }elsif($_=~ /\'(.*)/ ){	# beginnt einen String (das passiert z.B. beim Konstrukt < 'MO, DI, MI, DO, FR, SA, SO,     ' > )
    $res .= "\n   .ascii \"$1"; # in eine eigene neue Zeile
    $instring = 1;        
  }
  
  else{			# kein String	
	  if($newline == 1){		#neue Zeile
		if($type =~ /[b|B]/){
		   	$res .= "   .byte $_";
		}elsif($type =~ /[w|W]/){
			$res .= "   .word $_";
		}elsif($type =~ /[l|L]/){
			$res .= "   .long $_";
		}		
		$newline = 0;
	}else{			#mit Komma anhängen
		$res .= ",$_";
	}
   } 
 } # foreach
 
 if($instring == 1) {
        printf "Fehler in String-Definition !\n >>$command<<\n";
  
 }  
  
 $command = "$res";
}


$res = "";
if($command =~ /#\'(.{2,})\'/){ 			# ASCII Parameter mit mehr als 1 Zeichen, muss in GNU als Zahl interpretiert werden
 $count = length($1);
 foreach($i=0; $i < $count; $i++){
  $res .= sprintf("%x",ord(substr($1,$i,1)));
 }
 $command =~ s/#\'(.*)\'/#\/\*\'$1\'\*\/0x$res/; 
}


# define and fill (df.x)
if($command =~ /df\.[b|w|l]/){
 if($command =~ /df\.b/){                     # Byte
	$command =~ s/df\.b/  \.space /;
 }elsif($command =~ /df\.w/){		    # Word
        $command=~ /df\.w\s+(\d+),/;
 	if($1){
          $count = int($1)*2;
          $command =~ s/df\.w\s+\d+,/  \.space $count,/;
	}
 }elsif($command =~ /df\.l/){				    # Long
	$command =~ /df\.l\s+(\d+),/;
	if($1){
	  $count = int($1)*4;
	  $command =~ s/df\.l\s+\d+,/  \.space $count,/;
	}
 }
}

# rs.x Definitionen (müssen in ein BSS Segment...)
if($command =~ /rs\./) { 
 if($rswarned =~ /FALSE/){
  print "rs.x definition found in $src, manualy use bss segment \n";

  $rswarned = "TRUE";
 }
}

# Alignement (ds 0 = Alignment auf Wortgrenze)
$command =~ s/ds\s+0/  \.align 4/;

# define (ds.x <n>)
if($command =~ /ds\.[b|w|l]/){
 if($command =~ /ds\.b/){                     # Byte
	$command =~ s/ds\.b/  \.space /;
 }elsif($command =~ /ds\.w/){		    # Word
        $command=~ /ds\.w\s+(\d+),/;
 	if($1){
          $count = int($1)*2;
          $command =~ s/ds\.w\s+\d+,/  \ds $count/;
	}
 }elsif($command =~ /ds\.l/){				    # Long
	$command =~ /ds\.l\s+(\d+),/;
	if($1){
	  $count = int($1)*4;
	  $command =~ s/ds\.l\s+\d+,/  \.space $count/;
	}
 }
}

# Die ORG Anweisung
$command =~s/^\s*[o|O][r|R][g|G]\s+/  \.org  /;

# EQU Anweisung
 if($command =~ /(.+)[\s|\t]+[e|E][q|Q][u|U][\s|\t]+(.+)/){
       $command = "    .equ $1, $2";
     }


# ##############################################################
# Branch Improvement:
# http://web.mit.edu/gnu/doc/html/as_16.html#SEC187
#
#           Displacement
#           +-------------------------------------------------
#           |                68020   68000/10
# Pseudo-Op |BYTE    WORD    LONG    LONG      non-PC relative
#           +-------------------------------------------------
#      jbsr |bsrs    bsr     bsrl    jsr       jsr
#       jra |bras    bra     bral    jmp       jmp
# *     jXX |bXXs    bXX     bXXl    bNXs;jmpl bNXs;jmp
# *    dbXX |dbXX    dbXX       dbXX; bra; jmpl
# *    fjXX |fbXXw   fbXXw   fbXXl             fbNXw;jmp
#
# XX: condition
# NX: negative of condition XX
# ------------------------------------------
$command =~ s/^(\s*)bra\.?[s|w|l]?\s/$1jra /;
$command =~ s/^(\s*)bsr\.?[s|w|l]?\s/$1jbsr /;
$command =~ s/^(\s*)b(\w{2})\.?[s|l]?\s/$1j$2 /;
$command =~ s/^(\s*)fb(\w{2})[w|l]?\s/$1fj$2 /;
#$command =~ s/(\s+)db(\w{2})\.?[s|w|l]?/$1db$2 /;
$command =~ s/^(\s*)jmp\.?[s|w|l]?\s/$1jmp /;
$command =~ s/^(\s*)jsr\.?[s|l]?\s/$1jbsr /;
# ##############################################################


# Einige syntaktische Fehler ...
$command =~ s/exg\.l/exg/;	
# $command =~ s/bra\.s/bra/;

    
# $command =~ s/end//; # die Zeichenfolge "end" taucht in Befehlen auf....!! => fix me
         
# ToDo: moveq (=move.l) wird auf Werte > +/-127 angewendet, was unter GNU einen Fehler verursacht.
# .s funktioniert nicht mehr durchgaengig, wenn globale Sprungmarken verwendet werden
# am besten "normal" ohne .s, der Compiler optimiert dann
#       macros uebersetzen, nur bei 'move' aufpassen !!
$command =~ s/(\w+)\.s/$1/;

# # .b eliminieren. Ausnahmen: move.b, clr.b, cmp.b, tst.b  (andere ?) FIX!
# if(     $command =~ /(move\.b)/) { # move.b ist eine Ausnahme !!
# }elsif( $command =~ /(clr\.b)/) { # clr.b ist eine Ausnahme !!
# }elsif( $command =~ /(cmp\.b)/) { # cmp.b ist eine Ausnahme !!
# }elsif( $command =~ /(sub\.b)/) { # cmp.b ist eine Ausnahme !!
# }elsif( $command =~ /(tst\.b)/) { # tst.b ist eine Ausnahme !!
# }else{
#   $command =~ s/(\w+)\.b/$1/;
# }

if($command =~ /lea/)
{
#    printf(" Attention with lea on 68000 processor !! Check !\n");
}

$command =~ s/moveq\.?l?/move.l/; # GP Assembler special

}

# Ausgabe:

if($label) {
 print DST "$label  ";
 $label =~ s/\s*(\w+):/$1/;		# : im Label entfernen
 print DSTGLB "\.global $label\n"; 	# und als .global in *.global File schreiben
}

print DST $command if $command;
print DST " /* $comment */" if $comment;

print DST "\n";

}else
{
 print DST "\n";
}



}

END:

close(SRC);
close(DST);
close(DSTGLB);

}
close(DATEI);



