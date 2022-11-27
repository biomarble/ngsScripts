use strict;
use warnings;

die "USAGE: perl $0  db.fa  in.blast output\n" if(scalar @ARGV!=3);

open IN,$ARGV[0] or die $!; #swissprot.fa
my %info;
while(<IN>){
chomp;
next if($_!~/^>/);
my ($gid,$annid)=split /\s+/,$_,2;
$gid=~s/>//g;
$info{$gid}=$annid;
}
close IN;

open IN,$ARGV[1] or die $!; #blast file
open OUT,">$ARGV[2]" or die $!; #output file
while(<IN>){
chomp;
my ($gid,$annid)=split /\s+/,$_;
print OUT "$gid\t$info{$annid}\n";
}
close IN;
close OUT;
