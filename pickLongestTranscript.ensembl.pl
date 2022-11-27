use warnings;
use strict;

die "USAGE: perl $0 all.transcript.pep.fa  >allgene.pep.fa\nNOTE: input file must be downloaded from ENSEMBL!\n" if(scalar @ARGV !=1);
my %seq;
my %length;
$/="\n>";
my %gid2pid;
open IN,$ARGV[0] or die $!; 
while(<IN>){
    chomp;
    next if($_=~/^$/);
    my ($head,$seq)=split /\n/,$_,2;
    my ($pid,$str)=split /\s+/,$head,2;
    my $gid;
    if($str=~/gene:\s*([0-9a-zA-Z-_.]+)/){
        $gid=$1;
    }else{
        die $str;
    }
    $seq{$pid}=$seq;
    my $o=$seq;
    $o=~s/\n//g;
    my $len=length($o);
    if(!exists $length{$gid} or $length{$gid}<$len){
        $length{$gid}=$len;
        $gid2pid{$gid}=$pid;
    }
}
close IN;

$/="\n";
foreach my $gid(keys %gid2pid){
    print ">$gid   $gid2pid{$gid}\n";
    print "$seq{$gid2pid{$gid}}\n";
}
