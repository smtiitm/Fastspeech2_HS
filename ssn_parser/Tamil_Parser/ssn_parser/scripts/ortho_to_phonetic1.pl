#ortho_to_phonetic1
if(scalar(@ARGV)!=3)
{
	print "   Argument1 --> file for phonetic transcription\n";
	print "   Argument2 --> phone_list\n";
	print "   Argument2 --> output file\n";
	exit(0);
}
$num_words = scalar(split(/\s+/,cat($ARGV[0])));
$num_phones = scalar(split("\n",cat($ARGV[1])));
$word_start = 1;
open(phn_handle,">",@ARGV[2]);
while($word_start <= $num_words)
{
	@temp = split(/\s+/,cat($ARGV[0]));
	$word = @temp[$word_start-1];
	if($word ne "SIL")
	{
		$num = length($word);
		$phone_start1 = 0;
		while($phone_start1 < $num)
		{
			$p1 = substr($word,$phone_start1,2);
			$p2 = substr($word,$phone_start1,3);
			$p3 = substr($word,$phone_start1,4);
			$p4 = substr($word,$phone_start1,5);
			$p5 = substr($word,$phone_start1,6);
			$cou = scalar(grep(/\b$p1\b/,cat($ARGV[1])));
			$cou1 = scalar(grep(/\b$p2\b/,cat($ARGV[1])));
			$cou2 = scalar(grep(/\b$p3\b/,cat($ARGV[1])));
			$cou3 = scalar(grep(/\b$p4\b/,cat($ARGV[1])));
			$cou4 = scalar(grep(/\b$p5\b/,cat($ARGV[1])));
			if($cou4 ==1)
			{
				print phn_handle $p5."\n";
				$phone_start1 = $phone_start1 + 6;
			}
			elsif($cou3 ==1)
			{
				print phn_handle $p4."\n";
				$phone_start1 = $phone_start1 + 5;
			}
			elsif($cou2 ==1)
			{
				print phn_handle $p3."\n";
				$phone_start1 = $phone_start1 + 4;
			}
			elsif($cou1==1)
			{
				print phn_handle $p2."\n";
				$phone_start1 = $phone_start1 + 3;
			}
			elsif($cou==1)
			{
				print phn_handle $p1."\n";
				$phone_start1 = $phone_start1 + 2;
			}
			else
			{
				$p1 = substr($word,$phone_start1,1);
				if($p1 eq ",")
				{
					$phone_start1++
				}
				elsif ($p1 eq ".")
				{
					$phone_start1++
				}
				else
				{
					print phn_handle $p1."\n";
					$phone_start1++
				}
			}
		}
	}
	else
	{
		print phn_handle "SIL\n";
		break;
	}
	$word_start++;
}
close(phn_handle);
sub cat
{
	$val="";
	$file = $_[0];
	open (input, "<",$file) ||die;
	while(<input>)
	{
		$val.="$_";
	}
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
