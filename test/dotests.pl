#!/usr/bin/perl

print "compiling Greek mapping (uncompressed)...";
$errs = `teckit_compile SILGreek2004-04-27.map -z -o SILGreek.uncompressed.tec`;
print (($errs eq "" ? "ok" : "failed: $errs") . "\n");

print "comparing...";
$errs = `diff SILGreek.uncompressed.tec SILGreek2004-04-27.uncompressed.tec.orig`;
print (($errs eq "" ? "ok" : "failed: $errs") . "\n");

print "compiling Greek mapping (compressed)...";
$errs = `teckit_compile SILGreek2004-04-27.map -o SILGreek.tec`;
print (($errs eq "" ? "ok" : "failed: $errs") . "\n");

print "comparing...";
$errs = `diff SILGreek.tec SILGreek2004-04-27.tec.orig`;
print (($errs eq "" ? "ok" : "failed: $errs") . "\n");

print "converting plain-text file to unicode...";
$errs = `txtconv -t SILGreek.tec -i mrk.txt -o mrk.utf8.txt -nfc`;
print (($errs eq "" ? "ok" : "failed: $errs") . "\n");

print "converting back to legacy encoding...";
$errs = `txtconv -t SILGreek.tec -r -i mrk.utf8.txt -o mrk.bytes.txt`;
print (($errs eq "" ? "ok" : "failed: $errs") . "\n");

print "comparing...";
$errs = `diff mrk.txt mrk.bytes.txt`;
print (($errs eq "" ? "ok" : "failed: $errs") . "\n");

print "converting unicode to utf16 and nfd...";
$errs = `txtconv -i mrk.utf8.txt -o mrk.utf16be.txt -of utf16be -nfd`;
print (($errs eq "" ? "ok" : "failed: $errs") . "\n");

print "converting back to utf8 and nfc...";
$errs = `txtconv -i mrk.utf16be.txt -o mrk.utf8b.txt -of utf8 -nfc`;
print (($errs eq "" ? "ok" : "failed: $errs") . "\n");

print "comparing...";
$errs = `diff mrk.utf8.txt mrk.utf8b.txt`;
print (($errs eq "" ? "ok" : "failed: $errs") . "\n");

print "compiling ISO-8859-1 mapping for sfconv test...";
$errs = `teckit_compile ISO-8859-1.map`;
print (($errs eq "" ? "ok" : "failed: $errs") . "\n");

print "converting standard format file to unicode...";
$errs = `sfconv -8u -c GNT-map.xml -i Mrk-GNT.sf -o mrk.sf.utf8.txt -utf8 -bom`;
print (($errs eq "" ? "ok" : "failed: $errs") . "\n");

print "converting back to legacy encodings...";
$errs = `sfconv -u8 -c GNT-map.xml -i mrk.sf.utf8.txt -o mrk.sf.legacy.txt`;
print (($errs eq "" ? "ok" : "failed: $errs") . "\n");

print "comparing...";
$errs = `diff mrk.sf.legacy.txt mrk.sf.legacy.txt.orig`;
print (($errs eq "" ? "ok" : "failed: $errs") . "\n");

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
	print "done\n";
}
