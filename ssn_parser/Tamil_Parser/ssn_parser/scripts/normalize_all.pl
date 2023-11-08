use File::Slurp;
#use Roman;
use utf8;
#use POSIX;
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
	elsif(scalar(@arr1)!=0 || $txt eq "-" || $txt eq "/" || $txt eq "\\")
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
		#print "$txt";
		$tamil_cnt++;
	}
	$i++;
	#print "\n$i\t$txt \t>@arr[0]<\t:@arr1[0]:\t {@arr2[0]}";
}
#print "\neng $eng_cnt \nspl $spl_cnt \nTamil $tamil_cnt \nspace $space\nNum_count $num_cnt\n";
@spl_chr_map = split("\n",read_file("lists/spl_chr_map"));
#foreach $txt(@text)
for($j=0; $j<scalar(@text); $j++)
{
	$txt = @text[$j];
	$prev = @text[$j-1];
	$nxt = @text[$j+1];
	if($txt ne "(" && $txt ne ")" && $txt ne "\\" && $txt ne "^" && $txt ne "*" && $txt ne "+" && $txt ne "?" && $txt ne "{" && $txt ne "}" && $txt ne "[" && $txt ne "]" && $txt ne "|")
	{
		@arr = grep(/^$txt$/,@english);
		@arr1 = grep(/^$txt /,@spl_chr_map);
		@num_arr = grep(/\b$txt\b/,@number_file);
	}
	else
	{
		@arr = [];
		@arr1 = [];
		@num_arr = [];
	#	next LOOP;
	}
	if($txt eq "\$")
	{
		if($tamil_cnt > 0)
		{
			print file " டாலர் ";
		}
		elsif($eng_cnt > 0)
		{
			print file " dollar ";
		}
		elsif($eng_cnt == 0 && $tamil_cnt == 0)
		{
			print file " டாலர் ";
		}
	}
	elsif($txt eq "\+")
	{
		if($tamil_cnt > 0)
		{
			print file " ப்ளஸ் ";
		}
		elsif($eng_cnt > 0)
		{
			print file " plus ";
		}
		elsif($eng_cnt == 0 && $tamil_cnt == 0)
		{
			print file " ப்ளஸ் ";
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
	elsif($txt eq ".")
	{
	#	print "dot $txt\n";
		print file "$txt";
	}
	elsif($txt eq ',')
	{
		########For handling numbers ---------- inserted on September 2, 2014
		#print "Number $prev $txt $nxt\n";
#		$prev_num_arr = scalar(grep(/\b$prev\b/,@number_file));
#		$next_num_arr = scalar(grep(/\b$nxt\b/,@number_file));
		if($prev =~ /^\d+?$/ && $nxt =~ /^\d+?$/)
		{
			#print "Comma found\n";
		}
		else
		{
			print file "$txt";
		}
	}
	elsif($txt =~ /^\d+?$/ && (($prev ne "/" && $nxt ne "/") && ($prev ne "-" && $nxt ne "-") && ($prev ne "." && $nxt ne ".")))
	{
		if($prev =~ /^\d+?$/ && $nxt =~ /^\d+?$/)
		{
			print file "$txt";
		}
		elsif($prev =~ /^\d+?$/ && ($nxt eq "." || $nxt eq ","))
		{
			print file "$txt";
		}
		elsif(($prev eq "." || $prev eq ",") && $nxt =~ /^\d+?$/)
		{
			print file "$txt";
		}
		elsif($nxt eq "." || $nxt eq ",")
		{
			print file " $txt";
		}
		elsif($prev eq "." || $prev eq ",")
		{
			print file "$txt";
		}
		elsif($prev !=~ /^\d+?$/ && $nxt =~ /^\d+?$/ )
		{
			print file "$txt";
		}
		elsif(($next !=~ /^\d+?$/ && $next ne "." && $next ne ",") )
		{
			print file "$txt ";
		}
		elsif(($prev !=~ /^\d+?$/ && $prev ne "." && $prev ne ",") )
		{
			print file "$txt ";
		}
		else
		{
			print file "$txt";
		}
		
	}
	elsif(scalar(@arr)!=0)
	{
		print file $txt;
	}
	elsif(scalar(@arr1)!=0)
	{
		@map = split(/\s+/,@arr1[0]);
		if($tamil_cnt > 0)
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
		elsif($eng_cnt > 0)
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
		elsif($eng_cnt == 0 && $tamil_cnt == 0)
		{
			if(scalar(@map)==1)
			{
				print file " ";
			}
			elsif(scalar(@map)==2)
			{
				print file "@map[0]";				#Will be handled by lexicon
			}
			elsif(scalar(@map)==3)
			{
				print file " @map[0] ";				#Will be handled by lexicon
			}
			elsif(scalar(@map)==4)
			{
				print file " @map[0] ";				#Will be handled by lexicon
			}
			elsif(scalar(@map)==5)
			{
				print file " @map[0] ";				#Will be handled by lexicon
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
		print file "$1 - $2 ";
	}
	elsif($word =~ m!^(\d+)[.](\d+)$!) 
	{
		if($tamil_cnt > 0)
		{
			#Tamil
			######print file "$1 புள்ளி ";
			$sep_num = join(" ",split("",$2));
			######print file "$sep_num ";
		}
		elsif($eng_cnt == 0 && $tamil_cnt ==0 )
		{
			#print "only number\n";
			######print file "$1 புள்ளி ";
			$sep_num = join(" ",split("",$2));
			######print file "$sep_num ";
		}
		elsif($tamil_cnt == 0)
		{
			#English
			######print  file "$1 point ";
			$sep_num = join(" ",split("",$2));
			######print file "$sep_num ";
		}
		else
		{
			####print file "$1 புள்ளி ";
			$sep_num = join(" ",split("",$2));
			####print file "$sep_num ";
		}
		print file "$word ";
	}
	elsif($word =~ m/(\d+)/ && @wd[0] eq ".")
	{
		print file "$word ";
	}
	elsif($word =~ m/(\d+)/)
	{
		#print "$word\n";
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
#$ggggggg = read_file(@ARGV[1]);
#print ">>$ggggggg<<\n";
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
		print file "$word ";
	}
	elsif($word =~ m/(\d+)/ && @wd[0] eq ".")
	{
		print file "$word ";
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
	#if(isroman(@tmp[$i]))
	#{
	#	$arabic = arabic(@tmp[$i]);
		#print "Converted back, $roman_fifteen is $arabic_fifteen\n";
	#	print file "$arabic ";
	#}
	#elsif(@tmp[$i] eq "-")
	#{
	#	if(@tmp[$i-1] =~ /^\d+?$/ && @tmp[$i+1] =~ /^\d+?$/)
	#	{
	#		if($tamil_cnt > 0 && $eng_cnt == 0 )
	#		{
	#			print file "முதல் ";
	#		}
	#		else
	#		{
	#			print file "@tmp[$i] ";
	#		}
	#	}
	#	else
	#	{
	#		print file "@tmp[$i] ";
	#	}
	#}
	#else
	#{
		print file "@tmp[$i] ";
	#}
	$i++;	
}
close(file);
`perl scripts/replace_dot_by_sil.pl @ARGV[1]`;
