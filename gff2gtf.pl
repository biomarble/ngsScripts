use strict;
use warnings;
die "Convert GFF files into GTF format\nUSAGE: perl $0 genes.gff >genes.gtf\n" if(@ARGV !=1);
open IN,$ARGV[0] or die $!;
my ($gid,$tid);
my %hash;
while(<IN>){
	chomp;
	next if($_=~/#/);
	my @lines=split /\s+/,$_,9;
	my $str=pop @lines;
	my $out=join "\t",@lines;
	if($lines[2] =~/gene/i){
		if($str=~/ID=([^;]+);/i){
			$gid=$1;
		}
		$out.="\tgene_id \"$gid\";\n";
		print $out;
	}
	if($lines[2] =~/mRNA/i or $lines[2] =~/transcript/i){
		if($str=~/ID=([^;]+);/i){
			$tid=$1;
		}
		if($str=~/Parent=([^;]+);/i){
			$gid=$1;
		}
		$out.="\tgene_id \"$gid\"; transcript_id \"$tid\";\n";
		print $out;
	}
	if($lines[2] =~/utr/i){
		$out.="\tgene_id \"$gid\"; transcript_id \"$tid\";\n";
		print $out;
	}
	if($lines[2] =~/exon/i or $lines[2] =~/CDS/i){
		$hash{$tid}++;
		$out.="\tgene_id \"$gid\"; transcript_id \"$tid\"; exon_number \"$hash{$tid}\";\n";
		print $out;
	}
}
