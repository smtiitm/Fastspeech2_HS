#VUV
if(scalar(@ARGV)!=1)
{
	print "arg --> word file\n";
	exit(0);
}
$char = substr(cat($ARGV[0]),1,1);
$f1 = 0;
$f1 = scalar(grep(/\b$char\b/,split("\n",cat("lists/alphabets"))));
if($f1 == 0)
{
	open (out_word_handle,">","lists/out_word");
	#`perl scripts/transliterator.pl lists/english_tam_map $ARGV[0] lists/trans_word`;
	system("scripts/tamil_trans lists/tamil_map @ARGV[0] lists/trans_word");
	`perl scripts/ortho_to_phonetic1.pl lists/trans_word lists/phone_list phn`;
	$count = scalar(split("\n",cat("phn")));
	$start = 2;
	$phn = tail(head(cat("phn"),1),1);
	if($phn eq "c")
	{
		print out_word_handle " ";
		print out_word_handle "s";
	}
	else
	{
		print out_word_handle " ";
		print out_word_handle $phn;
	}
	while ($start <= $count)
	{
		$phn = tail(head(cat("phn"),$start),1);
		$c0 = $start - 1;
		$c1 = $start + 1;
		$c2 = $start + 2;
		$phn_1 = tail(head(cat("phn"),$c0),1);
		$phn_2 = tail(head(cat("phn"),$c1),1);
		if (($phn eq "c" && $phn_1 eq "c") || ($phn eq "c" && $phn_2 eq "c")|| ($phn eq "c" && $phn_1 eq "tx") )
		{
			print out_word_handle " ";
			print out_word_handle $phn;
		}
		elsif ($phn eq "c" && $phn_1 eq "nj")
		{
			print out_word_handle " ";
			print out_word_handle "j";
		}
		elsif ($phn eq "c" && $phn_1 ne "c")
		{
			print out_word_handle " ";
			print out_word_handle "s";
		}
		elsif($phn eq "rx" && $phn_2 eq "rx")
		{
			print out_word_handle " ";
			print out_word_handle "tx";
		}
		else
		{
			@temp_vuv = split("\n",cat("lists/vuv_list"));
			#print @temp_vuv;
			open(list_temp,">","lists/tmp");
			foreach $line1 (@temp_vuv)
			{
				@line_temp = split(" ",$line1);
				print list_temp @line_temp[0]."\n";
				#print @line_temp[0]."\n";
			}
			close(list_temp);
			$flg = scalar(grep(/\b$phn\b/,split("\n",cat("lists/tmp"))));
			$phn0 = tail(head(cat("phn"),$c0),1);
			$phn1 = tail(head(cat("phn"),$c1),1);
			$phn2 = tail(head(cat("phn"),$c2),1);
			if ($phn eq "u")
			{
				$flg_1 = scalar(grep(/$phn1/,split("\n",cat("lists/u_list"))));
				if(($start == $count) || ($flg_1 != 0 && $c1 == $count) || ($phn1 eq "k" && $phn2 eq "k" && $c0 != 1))
				{
					print out_word_handle " ";
					print out_word_handle "eu";
				}
				else
				{
					print out_word_handle " ";
					print out_word_handle $phn;
				}
			}
			elsif($phn eq "c")
			{
				if($phn0 eq "c" || $phn1 eq "c" || $c1 == $count)
				{
					print out_word_handle " ";
					print out_word_handle $phn;
				}
				elsif ($phn0 eq "nj")
				{
					print out_word_handle " ";
					print out_word_handle "j";
				}
				else
				{
					print out_word_handle " ";
					print out_word_handle "s";
				}
			}
			elsif($flg == 1)
			{
				@temp = split("\n",cat("lists/vuv_list"));
				open (list_nasal,">","lists/nasal");
				foreach $line_nasal (@temp)
				{
					@line_temp = split(" ",$line_nasal);
					print list_nasal @line_temp[2]."\n";
				}
				close(list_nasal);
				$flg1 = scalar(grep(/\b$phn0\b/,split("\n",cat("lists/vowel_list"))));
				$flg2 = scalar(grep(/\b$phn1\b/,split("\n",cat("lists/vowel_list"))));
				$flg3 = scalar(grep(/\b$phn0\b/,split("\n",cat("lists/nasal"))));
				$flg4 = scalar(grep(/\b$phn0\b/,split("\n",cat("lists/sv"))));
				if ($phn eq "p")
				{
					if (($flg1 == 1 && $flg2 == 1) || ($flg3 == 1 && $phn0 ne $phn) || ($phn0 eq "n"))
					{
						@phn_v_tmp = grep(/\b$phn\b/,split("\n",cat("lists/vuv_list")));
						@phn_v_tmp = split(" ",@phn_v_tmp[0]);
						$phn_v = @phn_v_tmp[1];
						print out_word_handle " ";
						print out_word_handle $phn_v;
					}
					else
					{
						print out_word_handle " ";
						print out_word_handle $phn;
					}
				}
				elsif(($flg1 == 1 && $flg2 == 1) || ($flg3 == 1 && $phn0 ne $phn) || ($flg4 == 1 && $flg2 == 1))
				{
					@temp_phn_v = grep(/\b$phn\b/,split("\n",cat("lists/vuv_list")));
					@temp_phn_v = split(" ",@temp_phn_v[0]);
					$phn_v = @temp_phn_v[1];
					print out_word_handle " ";
					print out_word_handle $phn_v;
				}
				else
				{
					print out_word_handle " ";
					print out_word_handle $phn;
				}
			}
			else
			{
				print out_word_handle " ";
				print out_word_handle $phn;
			}
		}
		$start++;
	}
	close(out_word_handle);
}
else
{
	#`perl scripts/transliterator.pl lists/english_tam_map $ARGV[0] lists/out_word`;
	system("scripts/tamil_trans lists/tamil_map @ARGV[0] lists/out_word");
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
	while($i<$line_h)
	{
		#$text_new = join("\n",$text_new,$text[$i]);
		#$text_head.="$text_h_split[$i]";
		if($i<$line_h-1)
		{
			$text_head.="$text_h_split[$i]\n";
		}
		elsif($i==$line_h-1)
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
		#$text_new = join("\n",$text_new,$text[$start]);
		#$text_tail.="$text_t_split[$start]\n";
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
