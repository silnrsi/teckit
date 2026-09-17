#!/usr/bin/env perl

use strict;
use warnings;

my $isWindows = $^O =~ /^MSWin/i;

my $sep  = $isWindows ? '\\' : '/';
my $diff = $isWindows ? "fc" : "diff";

my $srcdir = $ENV{'SRCDIR'} || "";
my $bindir = $ENV{'BINDIR'} || "../bin";

if ($srcdir && substr($srcdir, -1) ne $sep) { $srcdir .= ${sep}; }
if ($bindir && substr($bindir, -1) ne $sep) { $bindir .= ${sep}; }

my $status = 0; # OK

sub dotest {
	my ($description, $command) = @_;
	print "$description...";
	my $errs = `$command 2>&1`;
	my $output = "ok\n";
	if ($? != 0) {
		$status = 1;
		$output = "failed: $errs";
	}
	print " $output";
}

sub compare {
	my ($file1, $file2) = @_;
	dotest("comparing", "$diff $file1 $file2");
}

# Map
dotest("compiling Greek mapping (uncompressed)",
	"${bindir}teckit_compile ${srcdir}SILGreek2004-04-27.map -z -o SILGreek.uncompressed.tec");

compare("${srcdir}SILGreek2004-04-27.uncompressed.tec.orig", "SILGreek.uncompressed.tec");

dotest("compiling Greek mapping (compressed)",
	"${bindir}teckit_compile ${srcdir}SILGreek2004-04-27.map -o SILGreek.tec");
# Don't bother to check the compressed file as changes to the compression library can
# slightly change the resulting image. The tests below which use the compressed file
# should be sufficient to verify that it can be decompressed/used properly

# UTF-16LE map
dotest("converting plain-text file to utf16le",
	"${bindir}txtconv -t SILGreek.tec -i ${srcdir}mrk.text -o mrk.utf16le-nobom.txt -of utf16le -nobom -nfc");

dotest("converting back to legacy encoding",
	"${bindir}txtconv -t SILGreek.tec -r -i mrk.utf16le-nobom.txt -if utf16le -o mrk.bytes.txt");

compare("${srcdir}mrk.text", "mrk.bytes.txt");

# UTF-32BE map
dotest("converting plain-text file to utf32be",
	"${bindir}txtconv -t SILGreek.tec -i ${srcdir}mrk.text -o mrk.utf32be-nobom.txt -of utf32be -nobom -nfc");

dotest("converting back to legacy encoding",
	"${bindir}txtconv -t SILGreek.tec -r -i mrk.utf32be-nobom.txt -if utf32be -o mrk.bytes.txt");

compare("${srcdir}mrk.text", "mrk.bytes.txt");

# UTF-8 map
dotest("converting plain-text file to utf8",
	"${bindir}txtconv -t SILGreek.tec -i ${srcdir}mrk.text -o mrk.utf8.txt -nfc");

dotest("converting back to legacy encoding",
	"${bindir}txtconv -t SILGreek.tec -r -i mrk.utf8.txt -o mrk.bytes.txt");

compare("${srcdir}mrk.text", "mrk.bytes.txt");

# UTF-16BE BOM
dotest("converting unicode to utf16be and nfd",
	"${bindir}txtconv -i mrk.utf8.txt -o mrk.utf16be.txt -of utf16be -nfd");

dotest("converting back to utf8 and nfc",
	"${bindir}txtconv -i mrk.utf16be.txt -o mrk.utf8b.txt -of utf8 -nfc");

compare("mrk.utf8.txt", "mrk.utf8b.txt");

# UTF-32LE BOM
dotest("converting unicode to utf32le and nfd",
	"${bindir}txtconv -i mrk.utf8.txt -o mrk.utf32le.txt -of utf32le -nfd");

dotest("converting back to utf8 and nfc",
	"${bindir}txtconv -i mrk.utf32le.txt -o mrk.utf8b.txt -of utf8 -nfc");

compare("mrk.utf8.txt", "mrk.utf8b.txt");

# SFconv
dotest("compiling ISO-8859-1 mapping for sfconv test",
	"${bindir}teckit_compile ${srcdir}ISO-8859-1.map -o ISO-8859-1.tec");

# UTF-8
dotest("converting standard format file to utf8",
	"${bindir}sfconv -8u -c ${srcdir}GNT-map.xml -i ${srcdir}Mrk-GNT.sf -o mrk.sf.utf8-nobom.txt -utf8");

dotest("converting back to legacy encodings",
	"${bindir}sfconv -u8 -c ${srcdir}GNT-map.xml -i mrk.sf.utf8-nobom.txt -o mrk.sf.legacy.txt");

compare("${srcdir}mrk.sf.legacy.txt.orig", "mrk.sf.legacy.txt");

# UTF-16LE
dotest("converting standard format file to utf16le",
	"${bindir}sfconv -8u -c ${srcdir}GNT-map.xml -i ${srcdir}Mrk-GNT.sf -o mrk.sf.utf16le-nobom.txt -le");

dotest("converting back to legacy encodings",
	"${bindir}sfconv -u8 -c ${srcdir}GNT-map.xml -i mrk.sf.utf16le-nobom.txt -o mrk.sf.legacy.txt -le");

compare("${srcdir}mrk.sf.legacy.txt.orig", "mrk.sf.legacy.txt");

# UTF-16BE
dotest("converting standard format file to utf16be",
	"${bindir}sfconv -8u -c ${srcdir}GNT-map.xml -i ${srcdir}Mrk-GNT.sf -o mrk.sf.utf16be-nobom.txt -be");

dotest("converting back to legacy encodings",
	"${bindir}sfconv -u8 -c ${srcdir}GNT-map.xml -i mrk.sf.utf16be-nobom.txt -o mrk.sf.legacy.txt -be");

compare("${srcdir}mrk.sf.legacy.txt.orig", "mrk.sf.legacy.txt");

# UTF-8 BOM
dotest("converting standard format file to utf8 with bom",
	"${bindir}sfconv -8u -c ${srcdir}GNT-map.xml -i ${srcdir}Mrk-GNT.sf -o mrk.sf.utf8.txt -utf8 -bom");

dotest("converting back to legacy encodings",
	"${bindir}sfconv -u8 -c ${srcdir}GNT-map.xml -i mrk.sf.utf8.txt -o mrk.sf.legacy.txt");

compare("${srcdir}mrk.sf.legacy.txt.orig", "mrk.sf.legacy.txt");

# UTF-16LE BOM
dotest("converting standard format file to utf16le with bom",
	"${bindir}sfconv -8u -c ${srcdir}GNT-map.xml -i ${srcdir}Mrk-GNT.sf -o mrk.sf.utf16le.txt -le -bom");

dotest("converting back to legacy encodings",
	"${bindir}sfconv -u8 -c ${srcdir}GNT-map.xml -i mrk.sf.utf16le.txt -o mrk.sf.legacy.txt");

compare("${srcdir}mrk.sf.legacy.txt.orig", "mrk.sf.legacy.txt");

# UTF-16BE BOM
dotest("converting standard format file to utf16be with bom",
	"${bindir}sfconv -8u -c ${srcdir}GNT-map.xml -i ${srcdir}Mrk-GNT.sf -o mrk.sf.utf16be.txt -be -bom");

dotest("converting back to legacy encodings",
	"${bindir}sfconv -u8 -c ${srcdir}GNT-map.xml -i mrk.sf.utf16be.txt -o mrk.sf.legacy.txt");

compare("${srcdir}mrk.sf.legacy.txt.orig", "mrk.sf.legacy.txt");

# Maps
dotest("exporting Greek mapping",
	"${bindir}teckit_compile -x ${srcdir}SILGreek2004-04-27.map -o SILGreek2004-04-27.xml");

compare("${srcdir}SILGreek2004-04-27.xml.orig", "SILGreek2004-04-27.xml");
 
dotest("exporting ISO-8859-1 mapping",
	"${bindir}teckit_compile -x ${srcdir}ISO-8859-1.map -o ISO-8859-1.xml");

compare("${srcdir}ISO-8859-1.xml.orig", "ISO-8859-1.xml");

dotest("exporting Sen2Ajami mapping",
	"${bindir}teckit_compile -x ${srcdir}Sen2Ajami.map -o Sen2Ajami.xml");

compare("${srcdir}Sen2Ajami.xml.orig", "Sen2Ajami.xml");

print "preparing normalization tests...\n";
my @col;
open(FH, "< ${srcdir}NormalizationTest.txt") or die "can't open NormalizationTest.txt";
while (<FH>) {
	s/\#.*//;
	my @cols = split(/;/);
	if (defined $cols[4]) {
		foreach (1..5) {
			$col[$_] .= pack('U*', map { hex "0x$_" } split(/ /,$cols[$_ - 1])) . "\n";
		}
	}
}
close(FH);
foreach (1..5) {
	open(FH, ">:utf8", "NormCol$_.txt") or die "can't write to NormCol$_.txt";
	print FH $col[$_];
	system("${bindir}txtconv -i NormCol$_.txt -o NormCol$_.NFC.txt -of utf8 -nfc -nobom");
	system("${bindir}txtconv -i NormCol$_.txt -o NormCol$_.NFD.txt -of utf8 -nfd -nobom");
	close FH;
}
foreach ("2,1.NFC", "2,2.NFC", "2,3.NFC", "4,4.NFC", "4,5.NFC",
               "3,1.NFD", "3,2.NFD", "3,3.NFD", "5,4.NFD", "5,5.NFD") {
	my @pair = split(/,/, $_);
	compare("NormCol$pair[0].txt", "NormCol$pair[1].txt");
}
print "done\n";

if (1) {
	print "removing working files...";
	unlink("SILGreek.uncompressed.tec");
	unlink("SILGreek.tec");
	unlink("ISO-8859-1.tec");
	unlink("mrk.mrk.utf16le-nobom.txt");
	unlink("mrk.mrk.utf32be-nobom.txt");
	unlink("mrk.utf8.txt");
	unlink("mrk.utf8b.txt");
	unlink("mrk.utf16be.txt");
	unlink("mrk.utf32le.txt");
	unlink("mrk.bytes.txt");
	unlink("mrk.sf.utf8-nobom.txt");
	unlink("mrk.sf.utf16le-nobom.txt");
	unlink("mrk.sf.utf16be-nobom.txt");
	unlink("mrk.sf.utf8.txt");
	unlink("mrk.sf.utf16le.txt");
	unlink("mrk.sf.utf16be.txt");
	unlink("mrk.sf.legacy.txt");
	unlink("SILGreek2004-04-27.xml");
	unlink("ISO-8859-1.xml");
	unlink("Sen2Ajami.xml");
	while (<NormCol*.txt>) {
		unlink($_);
	}
	print " done\n";
}

exit $status;
