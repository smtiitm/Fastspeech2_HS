use File::Slurp;
use utf8;
if(scalar(@ARGV)!=2)
{
	print "\tArgv1 --> input text file\n";
	print "\tArgv2 --> output text file\n";
	exit(0);
}
open(file,">",@ARGV[1]);
@english = split("\n",read_file("lists/english"));
@spl_chr = split("\n",read_file("lists/spl_chr"));
@tamil = split("\n",read_file("lists/tamil"));
@number_file = split("\n",read_file("lists/number"));
@text = split("",read_file(@ARGV[0]));
$eng_cnt = 0;
$spl_cnt = 0;
$space = 0;
$tamil_cnt = 0;
$num_cnt = 0;
$i=0;
Foreach1: foreach $txt(@text)
{
	if($txt ne "(" && $txt ne ")"  && $txt ne "\\"  && $txt ne "." && $txt ne "^"  && $txt ne "*"  && $txt ne "+"  && $txt ne "?"  && $txt ne "{"  && $txt ne "}"  && $txt ne "[" && $txt ne "]" && $txt ne "|")
	{
		@arr = grep(/^$txt$/,@english);
		@arr1 = grep(/^$txt$/,@spl_chr);
		@arr2 = grep(/^$txt$/,@tamil);
		@arr3 = grep(/^$txt$/,@number_file);
	}
	else
	{
		@arr =[];@arr1=[];@arr2=[];
		$spl_cnt++;
		next Foreach1;
	}
	if($txt eq "\$")
	{
		$spl_cnt++;
	}
	elsif($txt eq " " || $txt eq "\t" || $txt eq "\n")
	{
		$space++;
	}
	elsif(scalar(@arr)!=0)
	{
		$eng_cnt++;
	}
	elsif(scalar(@arr1)!=0)
	{
		$spl_cnt++;
		#print @arr1[0];
	}
	elsif(scalar(@arr3)!=0)
	{
		$num_cnt++;
	}
	else
	{
		$tamil_cnt++;
	}
	$i++;
	#print "\n$i\t$txt \t>@arr[0]<\t:@arr1[0]:\t {@arr2[0]}";
}
#print "\neng $eng_cnt \tspl $spl_cnt \tTamil $tamil_cnt space $space\n";
@spl_chr_map = split("\n",read_file("lists/spl_chr_map"));
#foreach $txt(@text)
for($j=0; $j<scalar(@text); $j++)
{
	$txt = @text[$j];
	if($txt ne "(" && $txt ne ")" && $txt ne "\\" && $txt ne "^" && $txt ne "*" && $txt ne "+" && $txt ne "?" && $txt ne "{" && $txt ne "}" && $txt ne "[" && $txt ne "]" && $txt ne "|")
	{
		@arr = grep(/^$txt$/,@english);
		@arr1 = grep(/^$txt /,@spl_chr_map);
	}
	else
	{
		@arr = [];
		@arr1 = [];
	#	next LOOP;
	}
	if($txt eq "\$")
	{
		if($eng_cnt > 0)
		{
			print file " dollar ";
		}
		elsif($tamil_cnt > 0)
		{
			print file " டாலர் ";
		}
		elsif($eng_cnt == 0 && $tamil_cnt == 0)
		{
			print file " dollar ";
		}
	}
	elsif($txt eq "\+")
	{
		if($eng_cnt > 0)
		{
			print file " plus ";
		}
		elsif($tamil_cnt > 0)
		{
			print file " கூட்டல் ";
		}
		elsif($eng_cnt == 0 && $tamil_cnt == 0)
		{
			print file " plus ";
		}
	}
	elsif($txt eq "(" || $txt eq ")" || $txt eq "\\" || $txt eq "^"  || $txt eq "*" || $txt eq "?"  || $txt eq "{"  || $txt eq "}"  || $txt eq "[" || $txt eq "]" || $txt eq "|")
	{
		print file " ";
	}
	elsif($txt eq " " || $txt eq "\t" || $txt eq "\n")
	{
		print file " ";
	}
	elsif(scalar(@arr)!=0)
	{
		print file $txt;
	}
	elsif(scalar(@arr1)!=0)
	{
		@map = split(/\s+/,@arr1[0]);
		if($eng_cnt > 0)
		{
			if(scalar(@map)==1)
			{
				print file " ";
			}
			elsif(scalar(@map)==2)
                        {
                                print file "@map[1]";
                        }
			elsif(scalar(@map)==3)
			{
				print file " @map[1] ";
			}
			elsif(scalar(@map)==4)
			{
				print file " @map[1] @map[2] ";
			}
			elsif(scalar(@map)==5)
			{
				print file " @map[1] @map[2] ";
			}
			if(@map[1] eq "rupees")
			{
				$j = $j+2;
			}
		}
		elsif($tamil_cnt > 0)
		{
			if(scalar(@map)==1)
			{
				print file " ";
			}
			elsif(scalar(@map)==2)
                        {
                                print file "@map[1]";
                        }
			elsif(scalar(@map)==3)
			{
				print file " @map[2] ";
			}
			elsif(scalar(@map)==4)
			{
				print file " @map[3] ";
			}
			elsif(scalar(@map)==5)
			{
				print file " @map[3] @map[4] ";
			}
			if(@map[1] eq "rupees")
			{
				$j = $j+2;
			}			
		}
		elsif($eng_cnt == 0 && $tamil_cnt == 0)
		{
			if(scalar(@map)==1)
			{
				print file " ";
			}
			elsif(scalar(@map)==2)
			{
				print file "@map[1]";
			}
			elsif(scalar(@map)==3)
			{
				print file " @map[1] ";
			}
			elsif(scalar(@map)==4)
			{
				print file " @map[1] @map[2] ";
			}
			elsif(scalar(@map)==5)
			{
				print file " @map[1] @map[2] ";
			}
			if(@map[1] eq "rupees")
			{
				$j = $j+2;
			}
		}
	}
	else 
	{
		print file "$txt";
	}
}
close(file);
########################################################
########## First Level Date and number normalization
@tmp = split(/\s+/,read_file(@ARGV[1]));
open(file,">",@ARGV[1]);
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
	$temp="";
	$word = @tmp[$i];
	#print "$word\t";
	@wd = split("",$word);
	if(@wd[0] =~ /^\d+$/)
	{
		@wd_c = split(/,/,$word);
		foreach $digit (@wd_c)
		{
			#print file "$digit";
			$temp.=$digit;
		}
		if(@wd[scalar(@wd)-1] eq ',')
		{
			#print file ", ";
			$temp.=", ";
		}
		else
		{
			#print file " ";
			#$temp.=" ";
		}
		$word = $temp;
	}
	#print "$temp\n";
	if($word =~ m!^(\d+)[- /.](\d+)[- /.](\d+)$!)
	{
		#print file "$1 $2 $3 ";
		if($1 gt 12 && $2 gt 12)
		{
			print file "$1 $2 $3 ";
		}
		elsif($2 > 12)
		{
			print file "$2/$1/$3 ";
		}
		elsif($1 > 12)
		{
			print file "$1/$2/$3 ";
		}
		else
		{
			print file "$1/$2/$3 ";
		}
	}
	elsif($word =~ m!^(\d+)[-](\d+)$!) 
	{
		print file "$1 $2 ";
	}
	elsif($word =~ m!^(\d+)[.](\d+)$!) 
	{
		if($tamil_cnt > 0)
		{
			#Tamil
			print file "$1 புள்ளி ";
			$sep_num = join(" ",split("",$2));
			print file "$sep_num ";
		}
		elsif($eng_cnt == 0 && $tamil_cnt ==0 )
		{
			#only number
			print file "$1 புள்ளி ";
			$sep_num = join(" ",split("",$2));
			print file "$sep_num ";
		}
		elsif($tamil_cnt == 0)
		{
			#English
			print  file "$1 புள்ளி ";
			$sep_num = join(" ",split("",$2));
			print file "$sep_num ";
		}
		else
		{
			print file "$1 புள்ளி ";
			$sep_num = join(" ",split("",$2));
			print file "$sep_num ";
		}
	}
	elsif($word =~ m/(\d+)/)
	{
		$used = $1;
		$word =~ s/$used/ $used /g;
		print file "$word ";
	}
	else
	{
		print file "$word ";
	}
	#print file "$word ";
	$i++;
}
close(file);
####################################################
`perl -pi -e 's/-/ - /g;' @ARGV[1]`;
####################################################
########## second Level Date and number normalization
@tmp = split(/\s+/,read_file(@ARGV[1]));
open(file,">",@ARGV[1]);
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
	$temp="";
	$word = @tmp[$i];
	#print "$word\t";
	@wd = split("",$word);
	if(@wd[0] =~ /^\d+$/)
	{
		@wd_c = split(/,/,$word);
		foreach $digit (@wd_c)
		{
			#print file "$digit";
			$temp.=$digit;
		}
		if(@wd[scalar(@wd)-1] eq ',')
		{
			#print file ", ";
			$temp.=", ";
		}
		else
		{
			#print file " ";
			#$temp.=" ";
		}
		$word = $temp;
	}
	#print "$temp\n";
	if($word =~ m!^(\d+)[- /.](\d+)[- /.](\d+)$!)
	{
		#print file "$1 $2 $3 ";
		if($1 gt 12 && $2 gt 12)
		{
			print file "$1 $2 $3 ";
		}
		elsif($2 > 12)
		{
			print file "$2/$1/$3 ";
		}
		elsif($1 > 12)
		{
			print file "$1/$2/$3 ";

		}
		else
		{
			print file "$1/$2/$3 ";
		}
	}
	elsif($word =~ m!^(\d+)[-](\d+)$!) 
	{
		print file "$1 $2 ";
	}
	elsif($word =~ m/(\d+)/)
	{
		$used = $1;
		$word =~ s/$used/ $used /g;
		print file "$word ";
	}
	else
	{
		print file "$word ";
	}
	#print file "$word ";
	$i++;
}
close(file);
####################################################
@tmp = split(/\s+/,read_file(@ARGV[1]));
open(file,">",@ARGV[1]);
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

