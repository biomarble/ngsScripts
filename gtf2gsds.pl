use strict;
use warnings;
my $gtf=$ARGV[0];
open IN,$gtf or die $!;
open OUT1,">$gtf.gsds.bed" or die $!;
open OUT2,">$gtf.mRNA.txt" or die $!;
my %base;
while(<IN>){
	chomp;
	next if($_=~/#/);
	my ($chr,undef,$type,$start,$end,undef,$strand,undef,$str)=split /\t/,$_;
	next if($type=~/gene/i);
	my $tid;
	if($str=~/transcript_id "([^"]+)"/i){
		$tid=$1;
	}else{
		die $str;
	}
	if($type =~/mRNA/i or $type =~/transcript/i){
		if($strand eq "-"){
			$base{$tid}=$end;
		}else{
			$base{$tid}=$start;
		}
		print OUT2 "$tid\t$chr\t$start\t$end\t$strand\n";
	}
	next if($type !~/cds/i and $type !~/utr/i);
	my @k=sort {$a<=>$b}(abs($start-$base{$tid}),abs($end-$base{$tid}));
	$type=~s/five_prime_//g;
	$type=~s/three_prime_//g;
	print OUT1 "$tid\t$chr\t$type\t";
	print OUT1 join "\t",@k;
	print OUT1 "\n";
}
