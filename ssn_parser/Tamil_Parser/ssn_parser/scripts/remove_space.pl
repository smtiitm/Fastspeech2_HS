use File::Slurp;

@tmp = split(/\s+/,read_file(@ARGV[0]));
open(file,">",@ARGV[0]);
if(@tmp[0] eq "")
{
	$i=1;
}
else
{
	$i=0;
}
while($i<scalar(@tmp))
{
	print file "@tmp[$i] ";
	$i++;	
}
close(file);

