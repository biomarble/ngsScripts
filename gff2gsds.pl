use strict;
use warnings;
my $gff=$ARGV[0];
open IN,$gff or die $!;
open OUT1,">$gff.gsds.bed" or die $!;
open OUT2,">$gff.mRNA.txt" or die $!;
my %base;
while(<IN>){
	chomp;
	next if($_=~/#/);
	my ($chr,undef,$type,$start,$end,undef,$strand,undef,$str)=split /\t/,$_;
	next if($type=~/gene/i);
	my $ID;
	my $PID;
	if($str=~/ID=([^;]+)/i){
		$ID=$1;
	}else{
		die $str;
	}
	if($str=~/Parent=([^;]+)/i){
		$PID=$1;
	}else{
		die $str;
	}
	if($type =~/mRNA/i or $type =~/transcript/i){
		if($strand eq "-"){
			$base{$ID}=$end;
		}else{
			$base{$ID}=$start;
		}
		print OUT2 "$ID\t$chr\t$start\t$end\t$strand\n";
	}
	next if($type !~/cds/i and $type !~/utr/i);
	die "$PID\ngff file must be sorted !\nmRNA feature must before CDS/UTR\n" if(!exists $base{$PID});
	my @k=sort {$a<=>$b}(abs($start-$base{$PID}),abs($end-$base{$PID}));
	$type=~s/five_prime_//g;
	$type=~s/three_prime_//g;
	print OUT1 "$PID\t$chr\t$type\t";
	print OUT1 join "\t",@k;
	print OUT1 "\n";
}
