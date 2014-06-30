#!/usr/bin/perl

$srcdir = $ENV{'SRCDIR'};
$bindir = $ENV{'BINDIR'} || "../bin";

if ($srcdir =~ /[^\/]$/) { $srcdir .= "/"; }
if ($bindir =~ /[^\/]$/) { $bindir .= "/"; }

$status = 0; # OK

sub dotest {
	my ($description, $command) = @_;
	print "$description...";
	my $errs = `$command 2>&1`;
	my $output = "ok\n";
	if ($errs) {
		$status = 1;
		$output = "failed: $errs";
	}
	print " $output";
}

dotest("compiling Greek mapping (uncompressed)",
	"${bindir}teckit_compile ${srcdir}SILGreek2004-04-27.map -z -o SILGreek.uncompressed.tec");

dotest("comparing",
	"diff ${srcdir}SILGreek2004-04-27.uncompressed.tec.orig SILGreek.uncompressed.tec");

dotest("compiling Greek mapping (compressed)",
	"${bindir}teckit_compile ${srcdir}SILGreek2004-04-27.map -o SILGreek.tec");

dotest("comparing",
	"diff ${srcdir}SILGreek2004-04-27.tec.orig SILGreek.tec");

dotest("converting plain-text file to unicode",
	"${bindir}txtconv -t SILGreek.tec -i ${srcdir}mrk.txt -o mrk.utf8.txt -nfc");

dotest("converting back to legacy encoding",
	"${bindir}txtconv -t SILGreek.tec -r -i mrk.utf8.txt -o mrk.bytes.txt");

dotest("comparing",
	"diff ${srcdir}mrk.txt mrk.bytes.txt");

dotest("converting unicode to utf16 and nfd",
	"${bindir}txtconv -i mrk.utf8.txt -o mrk.utf16be.txt -of utf16be -nfd");

dotest("converting back to utf8 and nfc",
	"${bindir}txtconv -i mrk.utf16be.txt -o mrk.utf8b.txt -of utf8 -nfc");

dotest("comparing",
	"diff mrk.utf8.txt mrk.utf8b.txt");

dotest("compiling ISO-8859-1 mapping for sfconv test",
	"${bindir}teckit_compile ${srcdir}ISO-8859-1.map -o ISO-8859-1.tec");

dotest("converting standard format file to unicode",
	"${bindir}sfconv -8u -c ${srcdir}GNT-map.xml -i ${srcdir}Mrk-GNT.sf -o mrk.sf.utf8.txt -utf8 -bom");

dotest("converting back to legacy encodings",
	"${bindir}sfconv -u8 -c ${srcdir}GNT-map.xml -i mrk.sf.utf8.txt -o mrk.sf.legacy.txt");

dotest("comparing",
	"diff ${srcdir}mrk.sf.legacy.txt.orig mrk.sf.legacy.txt");


print "preparing normalization tests...\n";
open(FH, "< ${srcdir}NormalizationTest.txt") or die "can't open NormalizationTest.txt";
while (<FH>) {
	s/\#.*//;
	@cols = split(/;/);
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
foreach $diff ("2,1.NFC", "2,2.NFC", "2,3.NFC", "4,4.NFC", "4,5.NFC",
               "3,1.NFD", "3,2.NFD", "3,3.NFD", "5,4.NFD", "5,5.NFD") {
	@pair = split(/,/, $diff);
	$cmd = "diff NormCol$pair[0].txt NormCol$pair[1].txt";
	dotest($cmd, $cmd);
}
print "done\n";

if (1) {
	print "removing working files...";
	unlink("SILGreek.uncompressed.tec");
	unlink("SILGreek.tec");
	unlink("ISO-8859-1.tec");
	unlink("mrk.utf8.txt");
	unlink("mrk.utf8b.txt");
	unlink("mrk.utf16be.txt");
	unlink("mrk.bytes.txt");
	unlink("mrk.sf.utf8.txt");
	unlink("mrk.sf.legacy.txt");
	system("rm NormCol*.txt");
	print " done\n";
}

exit $status;
