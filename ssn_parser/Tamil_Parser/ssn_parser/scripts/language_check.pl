use File::Copy;
use File::Slurp;
if(scalar(@ARGV)!=2)
{
	print "ARGV1 --> Text file input\n";
	print "ARGV2 --> Text file output\n";
	exit(0);
}
@text = split(/\s+/,read_file(@ARGV[0]));
@tmp = split("\n",read_file("lists/english_text_oald"));
for($j=0;$j<=$#tmp;$j++)
{
	@tmp1 = split(/\s+/,@tmp[$j]);
	@phn_oald[$j] = @tmp1[0];
	@phn_cp[$j] = @tmp1[1];
}
open(file1,">",@ARGV[1]);
foreach $txt(@text)
{
	@first_char = split("",$txt);
	if(@first_char[0] =~ /^[a-zA-Z]+$/)
	{
		#print "IF $txt\n";
		open(file,">","etc/bi_txt");
		print file "(bi_1 \" $txt . \" )";
		close(file);
		open(lang,">","lang");
		print lang "eng";
		close(lang);
		copy("festvox/ssn_hts_demo_lexicon_english.scm","festvox/ssn_hts_demo_lexicon.scm");
		copy("festvox/ssn_hts_demo_tokenizer_eng.scm","festvox/ssn_hts_demo_tokenizer.scm");
		copy("festvox/ssn_hts_demo_clunits_eng.scm","festvox/ssn_hts_demo_clunits.scm");
		`$ENV{'FESTDIR'}/bin/festival -b festvox/build_clunits.scm '(build_prompts "etc/bi_txt")'`;
		copy("festvox/ssn_hts_demo_clunits_tam.scm","festvox/ssn_hts_demo_clunits.scm");
		copy("festvox/ssn_hts_demo_lexicon_tamil.scm","festvox/ssn_hts_demo_lexicon.scm");
		copy("festvox/ssn_hts_demo_tokenizer_tamil.scm","festvox/ssn_hts_demo_tokenizer.scm");
		@lab = split("\n",read_file("prompt-lab/bi_1.lab"));
		for(my $i=1;$i<=$#lab;$i++)
		{
			@phn = split(/\s+/,@lab[$i]);
			my ( $index ) =  grep { $phn_oald[$_] eq @phn[2] } 0..$#phn_oald;
			if(@phn[2] ne "SIL")
			{
				if($index ne "")
				{
					print file1 "@phn_cp[$index]";
				}
			}
		}
		if(@first_char[$#first_char] eq ",")
		{
			print file1 ", ";
		}
		elsif(@first_char[$#first_char] eq "\.")
		{
			print file1 ". ";
		}
		else
		{
			print file1 " ";
		}
	}
	else
	{
		#print "Else $txt\n";
		open(lang,">","lang");
		print lang "tam";
		close(lang);
		print file1 "$txt ";
	}
}
close(file1);
