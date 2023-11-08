#word_pronunciation
use File::Copy;
use File::Slurp;
if (scalar(@ARGV)!=6)
{
	print "arg1 --> phoneset_all\n";
	print "arg2 --> phoneset_uyir\n";
	print "arg3 --> phoneset_mei\n";
	print "arg4 --> phoneset_uyirmei\n";
	print "arg5 --> word_file\n";
	print "arg6 --> any\n";
	exit(0);
}
`rm syllables`;
@word_cont = read_file($ARGV[4]);
open(handle_w,">","word");
print handle_w @word_cont[$#word_cont];	#see lts rules. For ' in english i changed it
close(handle_w);
`echo SIL > syllables`;
`perl scripts/language_check.pl $ARGV[4] temp3`;
if(read_file("lang") eq "tam")
{
	`perl scripts/vuv.pl temp3`;
	`./scripts/correct_text lists/out_word lists/o_au_map lists/phone_list`
}
else
{
	copy("temp3","lists/out_word");
}
`perl scripts/ortho_to_phonetic1.pl lists/out_word $ARGV[0] phone`;
`perl scripts/syllable_from_char.pl phone $ARGV[1] $ARGV[2] $ARGV[3] >> syllables`;
#print cat("word");
$count = scalar(split("\n",cat("syllables")));
$start = 1;
open(handle1,">","$ARGV[5]/wordpronunciation");
print handle1 "(set! wordstruct ' ( ";
close(handle1);
while ($start <= $count)
{
	$syl1 = tail(head(cat("syllables"),$start),1);
	open(handle,">","syl1");
	print handle $syl1."\n";
	close(handle);
	`perl scripts/ortho_to_phonetic1.pl syl1 lists/phone_list syl2`;
	$num_phones = scalar(split("\n",cat("syl2")));
	$ph_start = 1;
	#open(handle,">","syl3");
	while ($ph_start <= $num_phones)
	{
		$phn = tail(head(cat("syl2"),$ph_start),1);
		`echo 0.1 125 $phn >> lab/1.lab`;
		#open(handle,">","syl3");
		if ($ph_start == 1)
		{
			open(handle,">","syl3");
			print handle $phn." ";
			close(handle);
		}
		elsif($ph_start < $num_phones)
		{
			open(handle,">>","syl3");
			print handle $phn." ";
			close(handle);
		}
		else
		{
			open(handle,">>","syl3");
			print handle $phn;
			close(handle);
		}
		$ph_start++;
	}
	#close(handle);
	$syl = cat("syl3");
	open(handle2,">>","$ARGV[5]/wordpronunciation");
	print handle2 "(($syl) 0)";
	print handle2 " ";
	close(handle2);
	$start++;
}
open(handle3,">>","$ARGV[5]/wordpronunciation");
print handle3 ") )";
close(handle3);
open(handle4,">","morph_tag1");
print handle4 "(set! a ".'"'."0".'")';
close(handle4);
#unlink(word);
unlink("prompt-lab/bi_1.lab");
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
