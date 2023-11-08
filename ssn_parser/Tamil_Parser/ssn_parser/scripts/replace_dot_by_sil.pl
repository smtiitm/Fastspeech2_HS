use File::Slurp;
if(scalar(@ARGV)!=1)
{
	print "\tArgv1 --> input and text file (will be overwritten)\n";
	exit(0);
}
@content = split("",read_file(@ARGV[0]));
open(file,">",@ARGV[0]);
for($i=0;$i<=$#content;$i++)
{
	$prev = @content[$i-1];
	$nxt = @content[$i+1];
	$txt = @content[$i];
	if($txt eq ".")
	{
		if($prev =~ /^\d+?$/ && $nxt =~ /^\d+?$/)		#number is 11.7
		{
			print file "$txt";
		}
		elsif($nxt =~ /^\d+?$/)							#number is .78
		{
			print file "$txt";
		}
		elsif($prev =~ /^\d+?$/ && $nxt !=~ /^\d+?$/)	#Result is 70. So we can conclude
		{
			print file ",";
		}
		else
		{
			print file ",";
		}
	}
	else
	{
		print file "$txt";
	}
}
close(file);
