use strict;
use warnings;
die "Convert GTF files into GFF format\nUSAGE: perl $0 genes.gtf >genes.gff\n" if(@ARGV !=1);
open IN,$ARGV[0] or die $!;
my ($gid,$tid);
my %hash;
while(<IN>){
	chomp;
	next if($_=~/#/);
	next if($_=~/^$/);
	my @lines=split /\s+/,$_,9;
	my $str=pop @lines;
	my $out=join "\t",@lines;
	if($lines[2] =~/gene/i){
		if($str=~/gene_id\s+"([^";]+)"/i){
			$gid=$1;
			$gid=~s/gene://g;
		}
		$out.="\tID=$gid;\n";
		print $out;
	}elsif($lines[2] =~/mRNA/i or $lines[2] =~/transcript/i){
		if($str=~/gene_id\s+"([^";]+)"/i){
			$gid=$1;
		}
		if($str=~/transcript_id\s+"([^";]+)"/i){
			$tid=$1;
			$tid=~s/transcript://g;
		}
		$out.="\tID=$tid;Parent=$gid;\n";
		print $out;
	}elsif($lines[2] =~/exon/i){
		if($str=~/gene_id\s+"([^";]+)"/i){
			$gid=$1;
			$gid=~s/gene://g;
		}
		if($str=~/transcript_id\s+"([^";]+)"/i){
			$tid=$1;
			$tid=~s/transcript://g;
		}
		$out.="\t";
		if($str=~/exon_id\s+"([^";]+)"/i){
			my $eid=$1;
			$out.="ID=$eid;";
		}
		$out.="Parent=$tid;\n";
		print $out;
	}elsif($lines[2] =~/CDS/i or $lines[2]=~/PRIME/i or $lines[2]=~/codon/i){
		if($str=~/gene_id\s+"([^";]+)"/i){
			$gid=$1;
			$gid=~s/gene://g;
		}
		if($str=~/transcript_id\s+"([^";]+)"/i){
			$tid=$1;
			$tid=~s/transcript://g;
		}
		$out.="\tParent=$tid;\n";
		print $out;
         }
}
