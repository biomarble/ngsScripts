use strict;
use warnings;
use File::Basename;

if(scalar @ARGV !=2 or !-e $ARGV[0] )
{
        print <<"End";
	author: PlantTech Technologies. Beijing.
        Usage: 
        用于合并多个htseq-count输出的表达文件,文件必须以_count_number.txt结尾
	输入存放表达文件的文件夹，以及输出文件的前缀即可

        run example: 
        	perl $0 inputDirectory  merged.counts.txt

        results:
        	merged.counts.txt   #count值 

End

        exit;
}



my %exp;
my %sample;
my %allcount;
my $outname=$ARGV[1];
my @files=glob "$ARGV[0]/*_count_number.txt";

foreach my $file(@files){
 readexp($file,\%exp,\%sample,\%allcount);
}

open OUT,">$outname" or die $!;
my $header="#ID\t";
$header.=join "\t",(sort keys %sample);
$header=~s/_count_number.txt//g;
print OUT "$header\n";
foreach my $gid(sort keys %exp){
	print OUT "$gid";
#	print OUT2 "$gid";
	foreach my $sample(sort keys %sample){
		if(exists $exp{$gid}{$sample}){
			print OUT "\t$exp{$gid}{$sample}";
		}else{
			print OUT "\tNA";
		}
		
	}
	print OUT "\n";
}
close OUT;
#close OUT2;

sub readexp{
	my ($filename,$hash,$sample,$all)=@_;
	open IN,$filename or die $!;
	my $allcount=0;
	my $samplename=basename($filename);
	$sample->{$samplename}=1;
	while(<IN>){
		next if($_=~/#/);
		next if($_=~/^$/);
		my ($id,$count)=split /\s+/,$_;
		next if($id=~/^_/);
		$allcount+=$count;
		$hash->{$id}{$samplename}=$count;
	}
	close IN;
	$all->{$samplename}=$allcount;
}
