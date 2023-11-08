#syllable_from_char
if (scalar(@ARGV) == 0)
{
	print "Arg1 --> character transcription";
	print "Arg2 --> lists/phoneset_uyir";
	print "Arg3 --> lists/phoneset_mei";
	print "Arg4 --> lists/phoneset_uyirmei";
	exit(0)
}
$num_char = scalar(split(/\s+/,cat($ARGV[0])));
$start = 1;
while ($start <= $num_char)
{
	$char1 = tail(head(cat($ARGV[0]),$start),1);
	$a0 = 0;
	$b0 = 0;
	$c0 = 0;
	$a0 = scalar(grep(/\b$char1\b/,split("\n",cat($ARGV[1]))));
	$b0 = scalar(grep(/\b$char1\b/,split("\n",cat($ARGV[2]))));
	$c0 = scalar(grep(/\b$char1\b/,split("\n",cat($ARGV[3]))));
	if($a0 == 1) # To check for V followed by
	{
		$start1 = $start + 1;
		$char2 = tail(head(cat($ARGV[0]),$start1),1);
		$start2 = $start + 2;
		$char3 = tail(head(cat($ARGV[0]),$start2),1);
		$start3 = $start + 3;
		$char4 = tail(head(cat($ARGV[0]),$start3),1);
		$start4 = $start + 4;
		$char5 = tail(head(cat($ARGV[0]),$start4),1);
		$a1 = 0;
		$a2 = 0;
		$a3 = 0;
		$a4 = 0;
		$a5 = 0;
		$a6 = 0;
		$a1 = scalar(grep(/\b$char2\b/,split("\n",cat($ARGV[2]))));
		$a2 = scalar(grep(/\b$char3\b/,split("\n",cat($ARGV[2]))));
		$a3 = scalar(grep(/\b$char2\b/,split("\n",cat($ARGV[3]))));
		$a4 = scalar(grep(/\b$char3\b/,split("\n",cat($ARGV[3]))));
		$a5 = scalar(grep(/\b$char4\b/,split("\n",cat($ARGV[2]))));
		$a6 = scalar(grep(/\b$char5\b/,split("\n",cat($ARGV[2]))));
		if (($a1 == 1 && $a2 == 1 && $a5 == 1 && $a6 == 1) && ($start <= $num_char - 4)) 	# Check for VCCCC unit eg. armst in armstrong
		{
			print $char1.$char2.$char3.$char4.$char5."\n";
			$start = $start + 5;
		}
		elsif (($a1 == 1 && $a2 == 1 && $a5 == 1) && ($start <= $num_char - 3))	# Check for VCCC unit eg. arms
		{
			print $char1.$char2.$char3.$char4."\n";
			$start = $start + 4;
		}
		elsif (($a1 == 1 && $a2 == 1) && ($start <= $num_char - 2))		# Check for VCC unit eg. arm
		{
			print $char1.$char2.$char3."\n";
			$start = $start + 3;
		}
		elsif (($a1 == 1) && ($start <= $num_char - 1))		# Check for VC unit eg. an
		{
			print $char1.$char2."\n";
			$start = $start + 2
		}
		else
		{
			print $char1."\n";				# If V is followed by another CV or V displays V unit alone.
			$start++;
		}
	}
	elsif($b0 == 1) 					# To check for C followed by
	{
		$start1 = $start + 1;
		$char2 = tail(head(cat($ARGV[0]),$start1),1);
		$start2 = $start + 2;
		$char3 = tail(head(cat($ARGV[0]),$start2),1);
		$start3 = $start + 3;
		$char4 = tail(head(cat($ARGV[0]),$start3),1);
		$start4 = $start + 4;
		$char5 = tail(head(cat($ARGV[0]),$start4),1);
		$start5 = $start + 5;
		$char6 = tail(head(cat($ARGV[0]),$start5),1);
		$b1 = 0;
		$b2 = 0;
		$b3 = 0;
		$b4 = 0;
		$b5 = 0;
		$b6 = 0;
		$b7 = 0;
		$b1  = scalar(grep(/\b$char2\b/,split("\n",cat($ARGV[2]))));
		$b2  = scalar(grep(/\b$char2\b/,split("\n",cat($ARGV[3]))));
		$b3  = scalar(grep(/\b$char3\b/,split("\n",cat($ARGV[2]))));
		$b4  = scalar(grep(/\b$char3\b/,split("\n",cat($ARGV[3]))));
		$b5  = scalar(grep(/\b$char4\b/,split("\n",cat($ARGV[2]))));
		$b6  = scalar(grep(/\b$char5\b/,split("\n",cat($ARGV[2]))));
		$b7  = scalar(grep(/\b$char6\b/,split("\n",cat($ARGV[2]))));
		if (($b1 == 1 && $b4 == 1 && $b5 == 1) && ($start <= $num_char - 3))       		# Check for CCCVC unit eg. skrIn
		{
			print $char1.$char2.$char3.$char4."\n";
			$start = $start + 4;
		}
		elsif (($b1 == 1 && $b4 == 1) && ($start <= $num_char - 2))       		# Check for CCCV unit eg. skrU
		{
			print $char1.$char2.$char3."\n";
			$start = $start + 3;
		}
		elsif (($b2 == 1 && $b3 == 1 && $b5 == 1 && $b6 == 1 && $b7 == 1) && ($start <= $num_char - 5)) 		# Check for CCVCCCC unit
		{
			print $char1.$char2.$char3.$char4.$char5.$char6."\n";
			$start = $start + 6;
		}
		elsif(($b2 == 1 && $b3 == 1 && $b5 == 1 && $b6 == 1) && ($start <= $num_char - 4)) 			# Check for CCVCCC unit eg. spOrTs
		{
			print $char1.$char2.$char3.$char4.$char5."\n";
			$start = $start + 5;
		}
		elsif(($b2 == 1 && $b3 == 1 && $b5 == 1) && ($start <= $num_char - 3)) 					# Check for CCVCC unit eg. spArk
		{
			print $char1.$char2.$char3.$char4."\n";
			$start = $start + 4;
		}
		elsif(($b2 == 1 && $b3 == 1) && ($start <= $num_char - 2))					# Check for CCVC unit eg. spAT
		{
			print $char1.$char2.$char3."\n";
			$start = $start + 3;
		}
		elsif(($b2 == 1) && ($start <= $num_char - 1))								# Check for CCV unit eg. srI
		{
			print $char1.$char2."\n";
			$start = $start + 2;
		}
		else
		{
			print $char1."\n";
			$start++;
		}
	}
	elsif($c0 == 1)					# To check for CV followed by
	{
		$start1 = $start + 1;
		$char2 = tail(head(cat($ARGV[0]),$start1),1);
		$start2 = $start + 2;
		$char3 = tail(head(cat($ARGV[0]),$start2),1);
		$start3 = $start + 3;
		$char4 = tail(head(cat($ARGV[0]),$start3),1);
		$start4 = $start + 4;
		$char5 = tail(head(cat($ARGV[0]),$start4),1);
		$start5 = $start + 5;
		$char6 = tail(head(cat($ARGV[0]),$start5),1);
		$c1 = 0;
		$c2 = 0;
		$c3 = 0;
		$c4 = 0;
		$c1 = scalar(grep(/\b$char2\b/,split("\n",cat($ARGV[2]))));
		$c2 = scalar(grep(/\b$char3\b/,split("\n",cat($ARGV[2]))));
		$c3 = scalar(grep(/\b$char4\b/,split("\n",cat($ARGV[2]))));
		$c4 = scalar(grep(/\b$char5\b/,split("\n",cat($ARGV[2]))));
		if(($c1 == 1 && $c2 == 1 && $c3 == 1 && $c4 == 1) && ($start <= $num_char - 4)) 		# Check for CVCCCC unit eg. varlfT
		{
			print $char1.$char2.$char3.$char4.$char5."\n";
			$start = $start + 5;
		}
		elsif(($c1 == 1 && $c2 == 1 && $c3 == 1) && ($start <= $num_char - 3))			# Check for CVCCC unit eg. hends
		{
			print $char1.$char2.$char3.$char4."\n";
			$start = $start + 4;
		}
		elsif(($c1 == 1 && $c2 == 1) && ($start <= $num_char - 2))                             # Check for CVCC unit eg. varth
		{
			print $char1.$char2.$char3."\n";
			$start = $start + 3;
		}
		elsif(($c1 == 1) && ($start <= $num_char - 1))                                          # Check for CVC unit eg. chak
		{
			print $char1.$char2."\n";
			$start = $start + 2;
		}
		else
		{
			print $char1."\n"; 	# If CV is followed by another CV or V displays CV unit alone.
			$start++;
		}
	}	
	else
	{
		print $char1."\n";
		$start++
	}
}
sub cat
{
	$val="";
	$file = $_[0];
	open (input, "<",$file) ||die;
	while(<input>)
	{
		#print $_;
		$val.="$_";
	}
	#print $val;
	return $val;
	close (input);
}
sub head
{
	$text_head="";
	@text_h_split = split("\n",$_[0]);
	$line_h = $_[1];
	$i =0;
	while($i < $line_h)
	{
		#$text_new = join("\n",$text_new,$text[$i]);
		#$text_head.="$text_h_split[$i]";
		if($i < $line_h-1)
		{
			$text_head.="$text_h_split[$i]\n";
		}
		elsif($i == $line_h-1)
		{
			$text_head.="$text_h_split[$i]";
		}
		$i++;
	}
	return $text_head;
}
sub tail
{
	$text_tail="";
	@text_t_split = split("\n",$_[0]);
	$line_t = $_[1];
	$total = scalar(@text_t_split);
	$start_t = $total - $line_t;
	while($start_t <$total)
	{
		#$text_new = join("\n",$text_new,$text[$start_t]);
		#$text_tail.="$text_t_split[$start_t]\n";
		if($start_t<$total-1)
		{
			$text_tail.="$text_t_split[$start_t]\n";
		}
		elsif($start_t==$total-1)
		{
			$text_tail.="$text_t_split[$start_t]";
		}
		$start_t++;
	}
	return $text_tail;
}
