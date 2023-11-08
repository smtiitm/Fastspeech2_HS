#!/usr/bin/perl 
no warnings;
use utf8;
#use Encode;

my $uvTagHex = "BFF";
my $vTagHex = "BDF";
my $ivTagHex = "BDE";
my $temptag = "BD9";

my $uvTagStr = "_uv";
my $vTagStr = "_v";
my $ivTagStr = "_iv";
my $tempstr = "_GEM";

my $BegTag = "_BEG";
my $MidTag = "_MID";
my $EndTag = "_END";
my $voiced_tag = 3039;
my $unVoiced_tag = 3071;
my $interVoiced_tag = 3038;
my $temp_Tag = 3033;
my $voiceDir = $ARGV[1];



$eachW = $ARGV[0];
my $voiced      = "B95 B9A B9F BA4 BAA";
my $nasals      = "B99 B9E BA3 BA8 BA9 BAE";
my $cons      = "BAF BB0 BB2 BB3 BB4";

my %voiced_hash = ();
my %nasal_hash  = ();
my %cons_hash = ();
my $for_morph;
@ps = split( /\s+/, $voiced );
my $Phoneset = "அ_BEG அ_BEG-x அ_MID அ_MID-x அக்_BEG அங்_BEG அச்_BEG அஞ்_BEG அட்_BEG அண்_BEG அத்_BEG அந்_BEG அப்_BEG அப்_MID அம்_BEG அய்_BEG அய்க்_BEG அர்_BEG அர்ச்_BEG அர்த்_BEG அர்ப்_BEG அல்_BEG அல்ட்_BEG அவ்_BEG அள்_BEG அற்_BEG அன்_BEG அன்ட்_BEG அஷ்_BEG அஸ்_BEG அக்ஷ்_BEG ஆ_BEG ஆ_BEG-x ஆ_END ஆ_END-x ஆ_MID ஆ_MID-x ஆக்_BEG ஆக்ஸ்_BEG ஆங்_BEG ஆச்_BEG ஆட்_BEG ஆண்_BEG ஆண்_MID ஆண்ட்_BEG ஆத்_BEG ஆந்_BEG ஆந்த்_BEG ஆப்_BEG ஆப்_END ஆம்_BEG ஆய்_BEG ஆர்_BEG ஆர்_MID ஆர்க்_BEG ஆல்_BEG ஆழ்_BEG ஆழ்த்_BEG ஆழ்ந்_BEG ஆள்_BEG ஆற்_GEM_BEG ஆன்_BEG ஆன்ட்_BEG ஆஸ்_BEG ஆஸ்ட்_BEG இ_BEG இ_BEG-x இ_MID இக்_BEG இங்_BEG இச்_BEG இச்_END இஞ்_BEG இட்_BEG இட்_MID இண்_BEG இத்_BEG இந்_BEG இந்த்_BEG இப்_BEG இம்_BEG இம்_END இர்_BEG இல்_BEG இவ்_BEG இன்_BEG இன்_MID இன்ஸ்_BEG இஷ்_BEG இஸ்_BEG ஈ_BEG ஈ_BEG-x ஈ_END ஈ_END-x ஈ_MID ஈ_MID-x ஈக்_BEG ஈட்_BEG ஈர்க்_BEG ஈர்த்_BEG ஈர்ப்_BEG ஈன்_BEG உ_BEG உ_BEG-x உ_END உ_MID உக்_BEG உக்_MID உங்_BEG உச்_BEG உட்_BEG உண்_BEG உத்_BEG உந்_BEG உப்_BEG உம்_BEG உல்_BEG உள்_BEG உற்_BEG உற்_GEM_BEG உன்_BEG உன்_MID உஜ்_BEG உஸ்_BEG ஊ_BEG ஊ_BEG-x ஊ_MID ஊக்_BEG ஊட்_BEG ஊம்_BEG ஊர்_BEG ஊர்க்_BEG ஊர்ட்_BEG ஊர்ப்_BEG ஊற்_GEM_BEG ஊன்_BEG எ_BEG எ_BEG-x எ_MID எ_MID-x எக்_BEG எக்ஸ்_BEG எங்_BEG எச்_BEG எஞ்_BEG எட்_BEG எண்_BEG எண்_MID எத்_BEG எத்_MID எந்_BEG எப்_BEG எம்_BEG எய்_BEG எய்ட்_BEG எல்_BEG எல்_END எவ்_BEG என்_BEG என்_END என்_MID என்ட்_BEG எஸ்_BEG எஸ்_MID ஏ_BEG ஏ_BEG-x ஏ_END ஏ_MID ஏ_MID-x ஏக்_BEG ஏங்_BEG ஏஞ்_BEG ஏண்_BEG ஏத்_BEG ஏப்_BEG ஏய்_BEG ஏய்க்_BEG ஏய்த்_BEG ஏய்ப்_BEG ஏர்_BEG ஏர்க்_BEG ஏழ்_BEG ஏற்_BEG ஏற்_GEM_BEG ஏன்_BEG ஐ_BEG ஐ_BEG-x ஐ_MID ஐங்_BEG ஐந்_BEG ஐப்_BEG ஐம்_BEG ஐன்ஸ்ட்_BEG ஐஸ்_BEG ஒ_BEG ஒ_BEG-x ஒட்_BEG ஒண்_BEG ஒத்_BEG ஒப்_BEG ஒம்_BEG ஒர்_BEG ஒர்க்_BEG ஒல்_BEG ஒவ்_BEG ஒற்_GEM_BEG ஒன்_BEG ஓ_BEG ஓ_BEG-x ஓ_END ஓ_END-x ஓ_MID ஓ_MID-x ஓட்_BEG ஓப்_BEG ஓய்_BEG ஓய்ந்_BEG ஓர்_BEG ஓன்_BEG ஔ_BEG ஔ_BEG-x ஃ_BEG ஃ_MID ஃக்_END ஃப்_END ஃப்_MID ஃப_uv_BEG ஃபா_uvக்ஸ்_BEG ஃபா_uvண்_BEG ஃபா_uvந்_MID ஃபா_uvர்_BEG ஃபா_uvஸ்_BEG ஃபி_uv_BEG ஃபி_v_END ஃபு_uv_MID ஃபெ_uv_BEG ஃபெ_uvட்_BEG ஃபெ_uvல்_BEG ஃபே_uv_BEG ஃபை_uv_BEG ஃபை_uvல்_BEG ஃபோ_uvர்ஸ்_BEG ஃபோ_uvல்_BEG ஃப்ட்_MID க்_BEG க்_END க்_MID க_uv_BEG க_uv_BEG-x க_uv_END க_uv_END-x க_uv_MID க_uv_MID-x க_uvக்_BEG க_uvக்_END க_uvக்_MID க_uvங்_BEG க_uvங்_MID க_uvச்_BEG க_uvச்_END க_uvச்_MID க_uvஞ்_BEG க_uvட்_BEG க_uvட்_END க_uvட்_MID க_uvண்_BEG க_uvண்_MID க_uvண்ட்_END க_uvத்_BEG க_uvத்_END க_uvத்_MID க_uvந்_BEG க_uvந்_MID க_uvந்த்_BEG க_uvப்_BEG க_uvப்_END க_uvப்_MID க_uvம்_BEG க_uvம்_END க_uvம்_MID க_uvம்ப்_BEG க_uvம்ய்_BEG க_uvர்_BEG க_uvர்_END க_uvர்_MID க_uvர்த்_BEG க_uvர்ப்_BEG க_uvர்ஸ்_END க_uvல்_BEG க_uvல்_END க_uvல்_MID க_uvவ்_BEG க_uvள்_BEG க_uvள்_END க_uvற்_BEG க_uvற்_GEM_BEG க_uvற்_MID க_uvன்_BEG க_uvன்_END க_uvன்ட்_BEG க_uvஷ்_BEG க_uvஸ்_BEG க_v_END க_v_END-x க_v_MID க_v_MID-x க_vக்_END க_vக்_MID க_vங்_MID க_vச்_END க_vச்_MID க_vட்_END க_vட்_MID க_vண்_END க_vண்_MID க_vத்_END க_vத்_MID க_vப்_END க_vப்_MID க_vம்_END க_vம்_MID க_vய்_END க_vர்_END க_vர்_MID க_vர்ச்_MID க_vர்த்_MID க_vர்ந்_MID க_vல்_END க_vல்_MID க_vழ்_END க_vழ்_MID க_vழ்ச்_MID க_vழ்த்_MID க_vழ்ந்_MID க_vள்_END க_vள்_MID க_vற்_GEM_MID க_vற்_MID க_vன்_END க_vன்_MID க_vஜ்_MID க_vஸ்_END க_vஸ்_MID க_vஸ்ட்_END கா_uv_BEG கா_uv_BEG-x கா_uv_END கா_uv_END-x கா_uv_MID கா_uv_MID-x கா_uvக்_BEG கா_uvக்_MID கா_uvங்_BEG கா_uvங்_MID கா_uvச்_END கா_uvச்_MID கா_uvஞ்_BEG கா_uvட்_BEG கா_uvட்_MID கா_uvண்_BEG கா_uvண்ட்_BEG கா_uvத்_BEG கா_uvத்_MID கா_uvந்_BEG கா_uvந்_MID கா_uvப்_BEG கா_uvம்_BEG கா_uvம்ப்_BEG கா_uvய்_BEG கா_uvய்_END கா_uvய்க்_BEG கா_uvய்ச்_BEG கா_uvய்ச்_MID கா_uvய்த்_MID கா_uvய்ந்_BEG கா_uvர்_BEG கா_uvர்_END கா_uvர்_MID கா_uvர்ந்_END கா_uvர்ந்_MID கா_uvர்ப்_BEG கா_uvர்ல்_BEG கா_uvர்ன்_END கா_uvல்_BEG கா_uvல்_END கா_uvற்_GEM_BEG கா_uvற்_GEM_MID கா_uvன்_BEG கா_uvன்_END கா_uvன்ஸ்_BEG கா_v_END கா_v_END-x கா_v_MID கா_v_MID-x கா_vக்_END கா_vக்_MID கா_vங்_END கா_vங்_MID கா_vட்_MID கா_vண்_MID கா_vப்_END கா_vப்_MID கா_vம்_END கா_vம்_MID கா_vய்_END கா_vய்_MID கா_vய்த்_MID கா_vர்_END கா_vல்_END கா_vவ்_END கா_vன்_END கா_vன்_MID கா_vஷ்_END கி_uv_BEG கி_uv_BEG-x கி_uv_END கி_uv_END-x கி_uv_MID கி_uv_MID-x கி_uvக்_END கி_uvக்_MID கி_uvச்_END கி_uvச்_MID கி_uvட்_BEG கி_uvட்_MID கி_uvண்_BEG கி_uvத்_END கி_uvப்_END கி_uvப்_MID கி_uvர்_BEG கி_uvல்_END கி_uvல்_MID கி_uvள்_BEG கி_uvள்_MID கி_uvற்_MID கி_uvன்_BEG கி_uvன்_END கி_uvன்_MID கி_uvஸ்_MID கி_uvஸ்ட்_MID கி_v_END கி_v_END-x கி_v_MID கி_v_MID-x கி_vக்_END கி_vக்_MID கி_vச்_END கி_vச்_MID கி_vட்_MID கி_vத்_END கி_vத்_MID கி_vந்_MID கி_vப்_END கி_vப்_MID கி_vம்_END கி_vம்_MID கி_vர்_MID கி_vர்ந்_MID கி_vல்_END கி_vழ்_MID கி_vழ்ச்_MID கி_vழ்ந்_MID கி_vள்_END கி_vற்_GEM_MID கி_vற்_MID கி_vன்_END கி_vன்_MID கி_vஸ்_END கீ_uv_BEG கீ_uv_BEG-x கீ_uv_MID கீ_uvச்_BEG கீ_uvத்_BEG கீ_uvர்_END கீ_uvர்த்_BEG கீ_uvல்_END கீ_uvல்_MID கீ_uvழ்_BEG கீ_uvழ்ப்_BEG கீ_uvற்_GEM_BEG கீ_v_MID கீ_v_MID-x கீ_vம்_END கீ_vழ்க்_END கீ_vஸ்_MID கு_uv_BEG கு_uv_BEG-x கு_uv_END கு_uv_END-x கு_uv_MID கு_uv_MID-x கு_uvக்_BEG கு_uvக்_END கு_uvங்_BEG கு_uvச்_BEG கு_uvச்_END கு_uvஞ்_BEG கு_uvஞ்_MID கு_uvட்_BEG கு_uvட்_MID கு_uvண்_BEG கு_uvண்_MID கு_uvத்_BEG கு_uvத்_END கு_uvத்_MID கு_uvந்_BEG கு_uvப்_BEG கு_uvப்_END கு_uvப்_MID கு_uvம்_BEG கு_uvம்_END கு_uvம்_MID கு_uvர்_END கு_uvல்_BEG கு_uvல்_MID கு_uvள்_BEG கு_uvள்_END கு_uvள்_MID கு_uvற்_GEM_BEG கு_uvற்_GEM_MID கு_uvன்_BEG கு_uvன்_MID கு_uvஷ்_BEG கு_uvஸ்_BEG கு_v_END கு_v_END-x கு_v_MID கு_v_MID-x கு_vக்_END கு_vக்_MID கு_vங்_MID கு_vச்_END கு_vட்_END கு_vண்_MID கு_vத்_MID கு_vந்_MID கு_vப்_MID கு_vம்_END கு_vம்_MID கு_vள்_MID கு_vற்_GEM_MID கு_vன்_MID கூ_uv_BEG கூ_uv_BEG-x கூ_uv_END கூ_uv_MID கூ_uv_MID-x கூ_uvச்_BEG கூ_uvட்_BEG கூ_uvட்_MID கூ_uvண்_BEG கூ_uvத்_BEG கூ_uvந்_BEG கூ_uvப்_BEG கூ_uvர்_BEG கூ_uvற்_GEM_BEG கூ_uvன்_BEG கூ_uvஸ்_BEG கூ_v_MID கூ_v_MID-x கூ_vப்_MID கூ_vர்_END கூ_vர்_MID கூ_vன்_END கெ_uv_BEG கெ_uv_BEG-x கெ_uv_MID கெ_uv_MID-x கெ_uvஞ்_BEG கெ_uvட்_BEG கெ_uvட்_END கெ_uvட்_MID கெ_uvண்_BEG கெ_uvத்_MID கெ_uvய்_BEG கெ_uvய்க்_BEG கெ_uvய்த்_BEG கெ_uvய்ம்_END கெ_uvல்_MID கெ_uvன்_BEG கெ_uvன்_MID கெ_v_MID கெ_vங்_MID கெ_vட்_END கெ_vல்_MID கே_uv_BEG கே_uv_BEG-x கே_uv_END கே_uv_END-x கே_uv_MID கே_uv_MID-x கே_uvக்_BEG கே_uvட்_BEG கே_uvத்_MID கே_uvப்_BEG கே_uvம்ப்_BEG கே_uvல்_BEG கே_uvல்_END கே_uvள்_BEG கே_uvள்_END கே_uvற்_GEM_MID கே_uvற்_MID கே_uvன்_BEG கே_uvன்_END கே_v_END கே_v_END-x கே_v_MID கே_v_MID-x கே_vட்_MID கே_vற்_GEM_MID கே_vன்_END கே_vஷ்_END கே_vஸ்_MID கை_uv_BEG கை_uv_BEG-x கை_uv_END கை_uv_END-x கை_uv_MID கை_uv_MID-x கை_uvக்_BEG கை_uvக்_END கை_uvக்_MID கை_uvச்_BEG கை_uvப்_BEG கை_uvப்_END கை_uvப்_MID கை_uvம்_MID கை_uvல்ஸ்_BEG கை_v_END கை_v_END-x கை_v_MID கை_v_MID-x கை_vக்_END கை_vக்_MID கை_vச்_MID கை_vத்_END கை_vத்_MID கை_vந்_MID கை_vப்_END கை_vப்_MID கொ_uv_BEG கொ_uv_BEG-x கொ_uv_END கொ_uv_MID கொ_uv_MID-x கொ_uvக்_BEG கொ_uvஞ்_BEG கொ_uvட்_BEG கொ_uvண்_BEG கொ_uvண்_MID கொ_uvத்_BEG கொ_uvப்_BEG கொ_uvம்_BEG கொ_uvய்_BEG கொ_uvல்_BEG கொ_uvள்_BEG கொ_uvள்_END கொ_uvள்_MID கொ_uvன்_BEG கொ_uvன்_MID கொ_v_MID கொ_v_MID-x கொ_vண்_MID கொ_vள்_END கொ_vள்_MID கொ_vற்_GEM_MID கொ_vன்_MID கோ_uv_BEG கோ_uv_BEG-x கோ_uv_END கோ_uv_END-x கோ_uv_MID கோ_uv_MID-x கோ_uvட்_BEG கோ_uvட்_END கோ_uvட்_MID கோ_uvண்_BEG கோ_uvப்_BEG கோ_uvர்க்_BEG கோ_uvர்ட்_BEG கோ_uvர்ட்_END கோ_uvர்த்_BEG கோ_uvல்_END கோ_uvவ்ஸ்_MID கோ_uvள்_BEG கோ_uvஷ்_BEG கோ_uvஸ்_MID கோ_v_END கோ_v_END-x கோ_v_MID கோ_v_MID-x கோ_vட்_MID கோ_vர்_END கோ_vல்_END கோ_vல்_MID கோ_vற்_MID கோ_vன்_END கோ_vன்_MID கோ_vஸ்_END கௌ_uv_BEG கௌ_uv_BEG-x கௌ_uv_MID க்ரூஸ்_BEG க்ரோ_BEG க்ரௌஞ்_BEG க்லௌ_BEG க்வார்ட்ஸ்_BEG க்ளு_BEG க்ளை_BEG ங்_END ங்_MID ங_MID ச்_END ச்_MID ச_iv_END ச_iv_END-x ச_iv_MID ச_iv_MID-x ச_ivக்_MID ச_ivங்_MID ச_ivட்_MID ச_ivத்_MID ச_ivந்_MID ச_ivப்_END ச_ivம்_END ச_ivம்_MID ச_ivர்_END ச_ivர்_MID ச_ivர்ட்_END ச_ivல்_END ச_ivன்_END ச_uv_BEG ச_uv_BEG-x ச_uv_END ச_uv_END-x ச_uv_MID ச_uv_MID-x ச_uvக்_BEG ச_uvக்_END ச_uvக்_MID ச_uvங்_BEG ச_uvங்_MID ச_uvச்_BEG ச_uvச்_END ச_uvச்_MID ச_uvஞ்_BEG ச_uvட்_BEG ச_uvண்_BEG ச_uvத்_BEG ச_uvத்_END ச_uvத்_MID ச_uvந்_BEG ச_uvந்_MID ச_uvந்த்_BEG ச_uvப்_BEG ச_uvப்_END ச_uvப்_MID ச_uvம்_BEG ச_uvம்_END ச_uvம்_MID ச_uvம்ப்_BEG ச_uvர்_BEG ச_uvர்_END ச_uvர்_MID ச_uvர்க்_BEG ச_uvர்ச்_BEG ச_uvர்ச்_END ச_uvர்ட்_BEG ச_uvர்ப்_BEG ச_uvல்_BEG ச_uvல்_END ச_uvல்_MID ச_uvல்ட்_END ச_uvற்_GEM_BEG ச_uvன்_BEG ச_uvன்_END ச_uvன்_MID ச_uvன்ட்_END ச_uvன்ஸ்_MID ச_uvஜ்_BEG ச_uvஸ்_BEG ச_uvஸ்_END ச_v_END ச_v_END-x ச_v_MID ச_v_MID-x ச_vப்_MID ச_vம்_END ச_vய்_MID ச_vர்_MID ச_vல்ஸ்_END ச_vள்_END ச_vன்_END சா_iv_END சா_iv_END-x சா_iv_MID சா_iv_MID-x சா_ivட்_MID சா_ivத்_END சா_ivம்_END சா_ivம்_MID சா_ivல்_END சா_uv_BEG சா_uv_BEG-x சா_uv_END சா_uv_END-x சா_uv_MID சா_uv_MID-x சா_uvக்_BEG சா_uvங்_BEG சா_uvங்_MID சா_uvட்_BEG சா_uvட்_MID சா_uvத்_BEG சா_uvந்_BEG சா_uvந்_MID சா_uvப்_BEG சா_uvப்ட்_BEG சா_uvம்_BEG சா_uvய்_BEG சா_uvய்த்_BEG சா_uvய்ந்_BEG சா_uvய்ப்_BEG சா_uvர்_BEG சா_uvர்_END சா_uvர்_MID சா_uvர்த்_BEG சா_uvர்ந்_BEG சா_uvல்_BEG சா_uvற்_GEM_MID சா_uvன்_BEG சா_uvன்_END சா_uvன்ட்_BEG சா_uvஜ்_END சா_uvஷ்_BEG சா_uvஸ்_BEG சா_v_END சா_v_MID சா_v_MID-x சா_vப்_END சி_iv_END சி_iv_END-x சி_iv_MID சி_iv_MID-x சி_ivக்_END சி_ivக்_MID சி_ivங்_END சி_ivங்_MID சி_ivட்_MID சி_ivத்_END சி_ivந்த்_END சி_ivப்_END சி_ivல்_END சி_ivற்_MID சி_ivன்_MID சி_ivஸ்_END சி_ivஸ்ட்_END சி_uv_BEG சி_uv_BEG-x சி_uv_END சி_uv_END-x சி_uv_MID சி_uv_MID-x சி_uvக்_BEG சி_uvக்_END சி_uvக்_MID சி_uvங்_BEG சி_uvங்_END சி_uvங்_MID சி_uvங்க்_BEG சி_uvச்_END சி_uvச்_MID சி_uvட்_BEG சி_uvத்_BEG சி_uvத்_END சி_uvத்_MID சி_uvந்_BEG சி_uvந்_MID சி_uvந்த்_END சி_uvப்_BEG சி_uvப்_END சி_uvப்_MID சி_uvப்ஸ்_BEG சி_uvம்_BEG சி_uvம்_MID சி_uvல்_BEG சி_uvல்_END சி_uvல்_MID சி_uvற்_BEG சி_uvற்_GEM_BEG சி_uvற்_MID சி_uvற்ப்_BEG சி_uvன்_BEG சி_uvன்_END சி_uvஷ்_BEG சி_uvஷ்_MID சி_uvஸ்_BEG சி_uvஸ்_END சி_uvஸ்_MID சி_uvஸ்ட்_BEG சி_v_END சி_v_END-x சி_v_MID சி_v_MID-x சி_vக்_MID சி_vங்_END சி_vங்_MID சி_vல்_END சி_vன்_END சீ_iv_END சீ_iv_END-x சீ_iv_MID சீ_ivட்_MID சீ_ivம்_END சீ_ivர்_END சீ_uv_BEG சீ_uv_BEG-x சீ_uv_MID சீ_uv_MID-x சீ_uvக்_BEG சீ_uvச்_BEG சீ_uvட்_BEG சீ_uvண்_BEG சீ_uvப்_BEG சீ_uvப்_END சீ_uvப்_MID சீ_uvய்த்_BEG சீ_uvர்_BEG சீ_uvர்த்_BEG சீ_uvழ்_BEG சீ_uvற்_GEM_BEG சீ_uvஸ்_BEG சீ_v_MID சீ_v_MID-x சு_iv_END சு_iv_END-x சு_iv_MID சு_iv_MID-x சு_ivக்_MID சு_ivங்_END சு_ivட்_MID சு_ivத்_END சு_ivத்_MID சு_ivம்_END சு_uv_BEG சு_uv_BEG-x சு_uv_END சு_uv_END-x சு_uv_MID சு_uv_MID-x சு_uvக்_BEG சு_uvக்_END சு_uvக்_MID சு_uvட்_BEG சு_uvண்_BEG சு_uvத்_BEG சு_uvத்_MID சு_uvந்_BEG சு_uvந்_MID சு_uvப்_BEG சு_uvப்_END சு_uvப்_MID சு_uvம்_BEG சு_uvம்_END சு_uvம்_MID சு_uvல்_BEG சு_uvல்_MID சு_uvள்_BEG சு_uvற்_GEM_BEG சு_uvற்_GEM_MID சு_uvன்_BEG சு_v_END சு_v_END-x சு_v_MID சு_v_MID-x சு_vம்_END சூ_iv_MID சூ_iv_MID-x சூ_ivல்_MID சூ_uv_BEG சூ_uv_BEG-x சூ_uv_MID சூ_uv_MID-x சூ_uvட்_BEG சூ_uvட்_END சூ_uvத்_BEG சூ_uvத்_END சூ_uvப்_BEG சூ_uvர்_BEG சூ_uvர்ப்_BEG சூ_uvழ்ச்_BEG சூ_uvழ்ந்_BEG சூ_v_MID சூ_v_MID-x செ_iv_MID செ_iv_MID-x செ_ivட்_END செ_ivந்_MID செ_ivப்_MID செ_ivய்_MID செ_ivல்_END செ_ivல்_MID செ_ivன்_MID செ_uv_BEG செ_uv_BEG-x செ_uv_MID செ_uv_MID-x செ_uvங்_BEG செ_uvஞ்_BEG செ_uvஞ்ச்_BEG செ_uvட்_BEG செ_uvத்_BEG செ_uvந்_BEG செ_uvப்_BEG செ_uvம்_BEG செ_uvய்_BEG செ_uvய்_END செ_uvய்_MID செ_uvல்_BEG செ_uvவ்_BEG செ_uvன்_BEG செ_uvன்_MID செ_uvன்ட்_BEG செ_v_MID செ_vன்_MID சே_iv_END சே_iv_MID சே_iv_MID-x சே_ivர்க்_MID சே_uv_BEG சே_uv_BEG-x சே_uv_END சே_uv_END-x சே_uv_MID சே_uv_MID-x சே_uvக்_BEG சே_uvட்_BEG சே_uvண்_BEG சே_uvத்_BEG சே_uvந்_BEG சே_uvந்_MID சே_uvய்_BEG சே_uvர்க்_BEG சே_uvர்க்_MID சே_uvர்த்_BEG சே_uvர்ந்_BEG சே_uvற்_GEM_BEG சே_uvற்_GEM_MID சே_uvஷ்_BEG சே_v_MID சே_v_MID-x சே_vட்_END சை_iv_END சை_iv_END-x சை_iv_MID சை_iv_MID-x சை_ivக்_MID சை_ivத்_END சை_ivப்_MID சை_uv_BEG சை_uv_BEG-x சை_uv_END சை_uv_END-x சை_uv_MID சை_uv_MID-x சை_uvக்_MID சை_uvச்_MID சை_uvத்_BEG சை_uvத்_END சை_uvத்_MID சை_uvந்_BEG சை_uvந்_MID சை_uvப்_BEG சை_uvப்_MID சை_uvய்_MID சை_uvன்_BEG சை_uvன்_END சை_v_END சை_v_END-x சை_v_MID சை_v_MID-x சை_vக்_END சை_vப்_END சொ_iv_MID சொ_ivத்_MID சொ_ivல்_MID சொ_ivன்_MID சொ_uv_BEG சொ_uv_BEG-x சொ_uv_END சொ_uv_MID சொ_uvட்_MID சொ_uvத்_BEG சொ_uvத்_MID சொ_uvந்_BEG சொ_uvப்_BEG சொ_uvப்_MID சொ_uvம்_BEG சொ_uvர்_BEG சொ_uvர்க்_BEG சொ_uvல்_BEG சொ_uvல்_END சொ_uvல்_MID சொ_uvற்_BEG சொ_uvன்_BEG சொ_v_MID சொ_vற்_MID சோ_iv_MID சோ_iv_MID-x சோ_ivந்_MID சோ_ivர்_MID சோ_uv_BEG சோ_uv_BEG-x சோ_uv_END சோ_uv_END-x சோ_uv_MID சோ_uv_MID-x சோ_uvங்_BEG சோ_uvப்_BEG சோ_uvம்_BEG சோ_uvர்_BEG சோ_uvர்ந்_BEG சோ_uvன்_END சோ_v_MID சோ_v_MID-x சோ_vத்_MID சௌ_uv_BEG சௌ_uv_BEG-x சௌ_uv_MID சௌ_uvக்_BEG சௌ_uvந்_BEG ஞ்_END ஞ்_MID ஞ_MID ஞ_MID-x ஞர்_END ஞர்_MID ஞன்_END ஞா_BEG ஞா_BEG-x ஞா_MID ஞா_MID-x ஞி_BEG ஞு_MID ஞெ_MID ஞை_END ஞை_MID ஞைத்_END ட்_BEG ட்_END ட்_MID ட_uv_BEG ட_uv_BEG-x ட_uv_END ட_uv_END-x ட_uv_MID ட_uv_MID-x ட_uvக்_END ட_uvக்_MID ட_uvங்_BEG ட_uvங்_END ட_uvங்_MID ட_uvச்_MID ட_uvட்_MID ட_uvத்_MID ட_uvந்_END ட_uvப்_BEG ட_uvப்_END ட_uvப்_MID ட_uvம்_BEG ட_uvம்_END ட_uvம்_MID ட_uvம்ஸ்_END ட_uvர்_BEG ட_uvர்_END ட_uvர்_MID ட_uvர்க்_BEG ட_uvர்ஸ்_MID ட_uvல்_BEG ட_uvல்_END ட_uvற்_GEM_MID ட_uvன்_END ட_uvன்_MID ட_uvன்ட்_END ட_uvன்ட்_MID ட_uvன்ஸ்_END ட_uvஸ்_END ட_uvஸ்_MID ட_v_END ட_v_END-x ட_v_MID ட_v_MID-x ட_vக்_END ட_vக்_MID ட_vங்_MID ட_vச்_END ட_vச்_MID ட_vட்_END ட_vட்_MID ட_vண்ட்_END ட_vத்_END ட_vத்_MID ட_vந்_MID ட_vப்_END ட_vப்_MID ட_vம்_END ட_vம்_MID ட_vர்_END ட_vர்_MID ட_vர்ச்_MID ட_vர்த்_MID ட_vர்ந்_MID ட_vர்ஸ்_MID ட_vல்_END ட_vல்_MID ட_vற்_MID ட_vன்_END ட_vன்_MID ட_vன்ஸ்_END ட_vஸ்_END ட_vஸ்_MID டா_uv_BEG டா_uv_BEG-x டா_uv_END டா_uv_END-x டா_uv_MID டா_uv_MID-x டா_uvக்_BEG டா_uvக்_MID டா_uvங்_MID டா_uvஞ்_MID டா_uvட்_BEG டா_uvண்_MID டா_uvத்_END டா_uvம்_BEG டா_uvம்_END டா_uvய்_END டா_uvர்_END டா_uvர்_MID டா_uvர்ட்_END டா_uvல்_END டா_uvள்_END டா_uvன்_END டா_uvஸ்க்_BEG டா_v_END டா_v_END-x டா_v_MID டா_v_MID-x டா_vக்_MID டா_vங்_MID டா_vந்_MID டா_vப்_MID டா_vம்_END டா_vய்_END டா_vர்_END டா_vர்_MID டா_vர்க்_MID டா_vல்_END டா_vள்_END டா_vள்_MID டா_vற்_END டா_vன்_END டா_vஸ்_END டி_uv_BEG டி_uv_BEG-x டி_uv_END டி_uv_END-x டி_uv_MID டி_uv_MID-x டி_uvக்_BEG டி_uvக்_END டி_uvக்_MID டி_uvக்ஸ்_BEG டி_uvக்ஸ்_END டி_uvங்_END டி_uvங்_MID டி_uvட்_MID டி_uvத்_END டி_uvத்_MID டி_uvப்_END டி_uvப்_MID டி_uvம்_BEG டி_uvல்_BEG டி_uvல்_END டி_uvல்_MID டி_uvவ்_END டி_uvற்_GEM_BEG டி_uvற்_MID டி_uvற்க்_MID டி_uvன்_BEG டி_uvன்_END டி_uvன்_MID டி_uvஷ்_END டி_uvஸ்_END டி_uvஸ்_MID டி_uvஸ்க்_BEG டி_v_END டி_v_END-x டி_v_MID டி_v_MID-x டி_vக்_END டி_vக்_MID டி_vங்_MID டி_vச்_END டி_vச்_MID டி_vஞ்_MID டி_vட்_MID டி_vத்_END டி_vத்_MID டி_vந்_MID டி_vப்_END டி_vப்_MID டி_vல்_END டி_vல்_MID டி_vவ்_MID டி_vற்_GEM_MID டி_vற்_MID டி_vன்_END டி_vன்_MID டி_vஸ்_END டி_vஸ்ட்_END டீ_uv_BEG டீ_uv_BEG-x டீ_uv_MID டீ_uv_MID-x டீ_uvர்_MID டீ_uvல்_END டீ_uvன்_END டீ_uvன்_MID டீ_uvஸ்_BEG டீ_uvஸ்_END டீ_v_MID டீ_v_MID-x டீ_vங்_MID டீ_vர்_END டீ_vன்_END டீ_vன்_MID டீ_vஸ்_END டீ_vஸ்_MID டு_uv_END டு_uv_END-x டு_uv_MID டு_uv_MID-x டு_uvக்_END டு_uvக்_MID டு_uvங்_MID டு_uvச்_END டு_uvட்_MID டு_uvத்_END டு_uvந்_MID டு_uvப்_END டு_uvப்_MID டு_uvம்_END டு_uvள்_MID டு_v_END டு_v_END-x டு_v_MID டு_v_MID-x டு_vக்_END டு_vக்_MID டு_vங்_MID டு_vச்_MID டு_vஞ்_END டு_vஞ்_MID டு_vத்_MID டு_vந்_END டு_vப்_MID டு_vம்_END டு_vம்_MID டு_vல்_MID டு_vல்ஸ்_END டு_vள்_MID டு_vன்_MID டு_vஸ்_END டூ_uv_MID டூ_uvர்_END டூ_uvல்_BEG டூ_v_END டூ_v_MID டூ_v_MID-x டூ_vத்_END டூ_vத்_MID டெ_uv_BEG டெ_uv_MID டெ_uv_MID-x டெ_uvட்_BEG டெ_uvண்_BEG டெ_uvய்ச்_BEG டெ_uvய்ம்_BEG டெ_uvர்_END டெ_uvல்_BEG டெ_uvன்_BEG டெ_uvன்_MID டெ_uvஸ்_END டெ_uvஸ்ட்_BEG டெ_v_MID டெ_v_MID-x டெ_vக்_END டெ_vக்ஸ்_END டெ_vங்_MID டெ_vட்_MID டெ_vண்_MID டெ_vம்_MID டெ_vய்ம்_MID டெ_vன்ட்_END டே_uv_BEG டே_uv_BEG-x டே_uv_END டே_uv_END-x டே_uv_MID டே_uv_MID-x டே_uvங்க்_BEG டே_uvட்_BEG டே_uvட்_MID டே_uvண்_MID டே_uvண்ட்_END டே_uvய்_BEG டே_uvன்_END டே_uvன்_MID டே_uvஸ்_BEG டே_v_END டே_v_END-x டே_v_MID டே_v_MID-x டே_vன்_END டே_vஜ்_END டை_uv_BEG டை_uv_BEG-x டை_uv_END டை_uv_END-x டை_uv_MID டை_uv_MID-x டை_uvக்_BEG டை_uvக்_MID டை_uvச்_END டை_uvட்_BEG டை_uvத்_END டை_uvப்_BEG டை_uvப்_END டை_v_END டை_v_END-x டை_v_MID டை_v_MID-x டை_vக்_END டை_vக்_MID டை_vச்_END டை_vச்_MID டை_vஞ்_MID டை_vத்_END டை_vத்_MID டை_vந்_MID டை_vப்_END டை_vப்_MID டொ_uv_BEG டொ_uv_END டொ_uv_MID டொ_uvன்_MID டொ_v_MID டொ_vன்_MID டோ_uv_BEG டோ_uv_BEG-x டோ_uv_END டோ_uv_END-x டோ_uv_MID டோ_uv_MID-x டோ_uvக்_BEG டோ_uvக்_MID டோ_uvம்_END டோ_uvல்_BEG டோ_uvல்ட்_END டோ_uvவ்ஸ்_BEG டோ_uvன்_BEG டோ_uvஸ்_END டோ_v_END டோ_v_END-x டோ_v_MID டோ_v_MID-x டோ_vத்_MID டோ_vம்_END டோ_vர்_END டோ_vன்_END டோ_vன்_MID டோ_vஷ்_END டோ_vஸ்_END டோ_vஸ்_MID டௌ_uv_BEG ட்ர_BEG ட்ரம்ஸ்_BEG ட்ரா_BEG ட்ரான்_BEG ட்ரி_BEG ட்ரிக்_BEG ட்ரூ_BEG ட்ரை_BEG ட்ரோ_BEG ட்ரோட்ஸ்_BEG ட்வெண்_BEG ண்_END ண்_MID ண_END ண_END-x ண_MID ண_MID-x ணக்_END ணக்_MID ணங்_MID ணச்_END ணட்_MID ணத்_END ணத்_MID ணந்_MID ணப்_END ணப்_MID ணம்_END ணம்_MID ணர்_END ணர்_MID ணர்ச்_MID ணர்த்_MID ணர்ந்_MID ணல்_END ணல்_MID ணற்_GEM_MID ணன்_END ணன்_MID ணா_END ணா_END-x ணா_MID ணா_MID-x ணார்_END ணால்_END ணான்_END ணி_END ணி_END-x ணி_MID ணி_MID-x ணிக்_END ணிக்_MID ணிச்_END ணித்_END ணித்_MID ணிந்_MID ணிப்_END ணிப்_MID ணில்_END ணிற்_MID ணிற்க்_MID ணின்_END ணின்_MID ணீ_MID ணீ_MID-x ணீங்_MID ணீட்_MID ணீர்_END ணீர்_MID ணீர்ப்_END ணு_END ணு_END-x ணு_MID ணு_MID-x ணுக்_MID ணுத்_MID ணுப்_END ணும்_END ணும்_MID ணுள்_MID ணூ_MID ணூ_MID-x ணூத்_MID ணூல்_END ணூற்_GEM_MID ணெ_MID ணெ_MID-x ணெண்_MID ணெய்_END ணெய்த்_END ணெய்ப்_END ணே_END ணே_END-x ணே_MID ணே_MID-x ணேஷ்_END ணேஸ்_MID ணை_END ணை_END-x ணை_MID ணை_MID-x ணைக்_END ணைக்_MID ணைச்_MID ணைத்_END ணைத்_MID ணைந்_MID ணைப்_END ணைப்_MID ணைய்_END ணொ_MID ணொ_MID-x ணோ_END ணோ_MID ணோம்_END த்_BEG த்_END த்_MID த_uv_BEG த_uv_BEG-x த_uv_END த_uv_END-x த_uv_MID த_uv_MID-x த_uvக்_BEG த_uvக்_MID த_uvங்_BEG த_uvங்_MID த_uvச்_BEG த_uvச்_END த_uvஞ்_BEG த_uvஞ்_END த_uvட்_BEG த_uvட்_MID த_uvண்_BEG த_uvண்_MID த_uvத்_BEG த_uvத்_END த_uvத்_MID த_uvந்_BEG த_uvப்_BEG த_uvப்_END த_uvப்_MID த_uvம்_BEG த_uvம்_END த_uvம்_MID த_uvர்_BEG த_uvர்_END த_uvர்_MID த_uvர்க்_BEG த_uvர்ப்_BEG த_uvல்_BEG த_uvல்_END த_uvல்_MID த_uvவ்_BEG த_uvள்_BEG த_uvள்_MID த_uvற்_BEG த_uvன்_BEG த_uvன்_END த_uvன்_MID த_uvஷ்_BEG த_v_END த_v_END-x த_v_MID த_v_MID-x த_vக்_END த_vக்_MID த_vங்_MID த_vச்_END த_vச்_MID த_vட்_MID த_vத்_END த_vத்_MID த_vந்_MID த_vப்_END த_vப்_MID த_vம்_END த_vம்_MID த_vய்_MID த_vர்_END த_vர்_MID த_vர்த்_END த_vல்_END த_vல்_MID த_vவ்_END த_vவ்_MID த_vழ்_END த_vழ்_MID த_vள்_END த_vற்_END த_vற்_GEM_MID த_vற்_MID த_vற்க்_MID த_vன்_END த_vன்_MID த_vஸ்_END த_vஸ்_MID தா_uv_BEG தா_uv_BEG-x தா_uv_END தா_uv_END-x தா_uv_MID தா_uv_MID-x தா_uvக்_BEG தா_uvக்_MID தா_uvக்க்_BEG தா_uvங்_BEG தா_uvங்_MID தா_uvட்_BEG தா_uvட்_MID தா_uvண்_BEG தா_uvண்_MID தா_uvத்_BEG தா_uvத்_END தா_uvம்_BEG தா_uvம்_END தா_uvம்_MID தா_uvய்_BEG தா_uvய்_END தா_uvய்க்_BEG தா_uvர்_BEG தா_uvர்_END தா_uvர்_MID தா_uvர்க்_BEG தா_uvல்_END தா_uvல்ஸ்_BEG தா_uvழ்_BEG தா_uvழ்த்_BEG தா_uvழ்ந்_BEG தா_uvழ்ப்_BEG தா_uvள்_END தா_uvற்_END தா_uvற்_GEM_MID தா_uvன்_BEG தா_uvன்_END தா_uvஜ்_BEG தா_uvஸ்_BEG தா_v_END தா_v_END-x தா_v_MID தா_v_MID-x தா_vக்_MID தா_vச்_MID தா_vஞ்_MID தா_vட்_MID தா_vத்_MID தா_vந்_MID தா_vப்_END தா_vம்_END தா_vய்_END தா_vய்ச்_END தா_vர்_END தா_vர்_MID தா_vல்_END தா_vள்_END தா_vன்_END தா_vன்_MID தா_vஸ்_END தி_uv_BEG தி_uv_BEG-x தி_uv_END தி_uv_END-x தி_uv_MID தி_uv_MID-x தி_uvக்_BEG தி_uvக்_END தி_uvக்_MID தி_uvங்_BEG தி_uvச்_END தி_uvட்_BEG தி_uvட்_MID தி_uvண்_BEG தி_uvத்_MID தி_uvப்_BEG தி_uvப்_END தி_uvப்_MID தி_uvர்க்_MID தி_uvல்_BEG தி_uvல்_END தி_uvல்_MID தி_uvவ்_BEG தி_uvற்_END தி_uvற்_MID தி_uvற்க்_MID தி_uvன்_BEG தி_uvன்_END தி_uvன்_MID தி_v_END தி_v_END-x தி_v_MID தி_v_MID-x தி_vக்_END தி_vக்_MID தி_vச்_END தி_vச்_MID தி_vட்_MID தி_vத்_MID தி_vப்_MID தி_vர்_END தி_vர்_MID தி_vர்க்_END தி_vர்க்_MID தி_vர்ச்_MID தி_vர்த்_MID தி_vர்ந்_MID தி_vர்ப்_MID தி_vர்ஷ்_MID தி_vல்_END தி_vல்_MID தி_vற்_GEM_MID தி_vற்_MID தி_vன்_END தி_vன்_MID தி_vஷ்_MID தீ_uv_BEG தீ_uv_BEG-x தீ_uv_MID தீ_uv_MID-x தீ_uvக்_BEG தீ_uvங்_BEG தீ_uvட்_BEG தீ_uvண்_BEG தீ_uvப்_BEG தீ_uvர்_BEG தீ_uvர்_MID தீ_uvர்க்_BEG தீ_uvர்த்_BEG தீ_uvர்ந்_BEG தீ_uvர்ப்_BEG தீ_uvவ்ஸ்_BEG தீ_uvஸ்_BEG தீ_uvஸ்_MID தீ_v_MID தீ_v_MID-x தீ_vக்_END தீ_vக்_MID தீ_vர்_END தீ_vர்_MID தீ_vர்ந்_MID தீ_vன்_END தீ_vஸ்_END து_uv_BEG து_uv_BEG-x து_uv_END து_uv_END-x து_uv_MID து_uv_MID-x து_uvக்_BEG து_uvக்_END து_uvக்_MID து_uvங்_MID து_uvச்_END து_uvட்_BEG து_uvண்_BEG து_uvத்_END து_uvத்_MID து_uvந்_BEG து_uvப்_BEG து_uvப்_END து_uvப்_MID து_uvம்_END து_uvம்_MID து_uvர்_BEG து_uvர்ப்_BEG து_uvல்_BEG து_uvல்_END து_uvள்_BEG து_uvள்_END து_uvள்_MID து_uvன்_BEG து_uvஷ்_BEG து_v_END து_v_END-x து_v_MID து_v_MID-x து_vக்_END து_vக்_MID து_vங்_END து_vங்_MID து_vச்_MID து_vண்_MID து_vத்_END து_vத்_MID து_vந்_MID து_vப்_END து_vப்_MID து_vம்_END து_vம்_MID து_vர்_END து_vர்_MID து_vல்_MID து_vள்_MID து_vன்_MID து_vஷ்_MID தூ_uv_BEG தூ_uv_BEG-x தூ_uv_MID தூ_uv_MID-x தூ_uvக்_BEG தூ_uvக்_MID தூ_uvங்_BEG தூ_uvண்_BEG தூ_uvத்_BEG தூ_uvம்_BEG தூ_uvய்_BEG தூ_uvள்_BEG தூ_uvள்_END தூ_uvற்_GEM_BEG தூ_v_MID தூ_v_MID-x தூ_vட்_MID தூ_vர்_END தெ_uv_BEG தெ_uv_BEG-x தெ_uv_MID தெ_uv_MID-x தெ_uvண்_BEG தெ_uvப்_BEG தெ_uvய்_BEG தெ_uvற்_BEG தெ_uvன்_BEG தெ_uvன்_MID தெ_v_MID தெ_v_MID-x தெ_vப்_MID தெ_vம்_END தெ_vல்_MID தெ_vற்_GEM_MID தெ_vன்_END தெ_vன்_MID தே_uv_BEG தே_uv_BEG-x தே_uv_END தே_uv_END-x தே_uv_MID தே_uv_MID-x தே_uvக்_BEG தே_uvங்_BEG தே_uvம்ஸ்_BEG தே_uvய்ந்_BEG தே_uvர்_BEG தே_uvர்_MID தே_uvர்க்_BEG தே_uvர்ச்_BEG தே_uvவ்_BEG தே_uvள்_BEG தே_uvற்_GEM_BEG தே_uvன்_BEG தே_uvன்_END தே_v_END தே_v_END-x தே_v_MID தே_v_MID-x தே_vப்_MID தே_vய்_MID தே_vர்_MID தே_vவ்_END தே_vன்_END தை_uv_BEG தை_uv_BEG-x தை_uv_END தை_uv_END-x தை_uv_MID தை_uv_MID-x தை_uvக்_END தை_uvக்_MID தை_uvச்_END தை_uvத்_END தை_uvத்_MID தை_uvந்_MID தை_uvப்_BEG தை_uvப்_END தை_uvப்_MID தை_v_END தை_v_END-x தை_v_MID தை_v_MID-x தை_vக்_END தை_vக்_MID தை_vச்_END தை_vச்_MID தை_vத்_END தை_vத்_MID தை_vந்_MID தை_vப்_END தை_vப்_MID தொ_uv_BEG தொ_uv_BEG-x தொ_uv_MID தொ_uv_MID-x தொ_uvக்_BEG தொ_uvங்_BEG தொ_uvட்_BEG தொ_uvட்_MID தொ_uvண்_BEG தொ_uvந்_BEG தொ_uvப்_BEG தொ_uvல்_BEG தொ_uvள்_BEG தொ_uvற்_GEM_BEG தொ_uvன்_BEG தொ_uvன்_MID தொ_v_MID தொ_v_MID-x தொ_vன்_MID தோ_uv_BEG தோ_uv_BEG-x தோ_uv_END தோ_uv_END-x தோ_uv_MID தோ_uv_MID-x தோ_uvங்_MID தோ_uvட்_BEG தோ_uvட்_END தோ_uvட்_MID தோ_uvண்_BEG தோ_uvம்_END தோ_uvய்_END தோ_uvய்ந்_BEG தோ_uvல்_BEG தோ_uvள்_BEG தோ_uvற்_BEG தோ_uvற்_GEM_BEG தோ_uvன்_BEG தோ_uvன்_MID தோ_uvஸ்_BEG தோ_v_END தோ_v_END-x தோ_v_MID தோ_v_MID-x தோ_vக்_END தோ_vங்_MID தோ_vப்_MID தோ_vம்_END தோ_vய்_END தோ_vர்_END தோ_vல்_END தோ_vல்_MID தோ_vஷ்_END தௌ_uv_BEG தௌ_uvம்_BEG த்ஸோங்_BEG ந்_END ந்_MID ந_BEG ந_BEG-x ந_MID ந_MID-x நச்_BEG நஞ்_BEG நட்_BEG நண்_BEG நத்_END நந்_BEG நந்_MID நம்_BEG நம்_MID நர்_BEG நர்_END நர்_MID நல்_BEG நல்_MID நள்_BEG நற்_BEG நற்_GEM_BEG நற்_MID நன்_BEG நஷ்_BEG நா_BEG நா_BEG-x நா_MID நா_MID-x நாக்_BEG நாங்_BEG நாட்_BEG நாட்_END நாட்_MID நாண்_BEG நாத்_MID நாப்_BEG நாம்_BEG நாய்_BEG நாய்_END நாய்_MID நாய்க்_BEG நார்_BEG நால்_BEG நால்_END நாள்_BEG நாள்_END நாள்_MID நாற்_BEG நாற்_GEM_BEG நாற்_GEM_MID நான்_BEG நான்_MID நான்ஸ்_BEG நி_BEG நி_BEG-x நி_MID நி_MID-x நிக்_BEG நிச்_BEG நித்_BEG நிந்_MID நிம்_BEG நிர்_BEG நிர்_MID நிர்ப்_BEG நில்_BEG நிற்_BEG நிற்_MID நின்_BEG நிஷ்_BEG நீ_BEG நீ_BEG-x நீ_MID நீ_MID-x நீக்_BEG நீங்_BEG நீட்_BEG நீண்_BEG நீத்_BEG நீந்_BEG நீப்ஸ்_BEG நீர்_BEG நீர்_END நீர்க்_BEG நீர்க்_END நீர்ச்_BEG நீர்ப்_BEG நீல்_BEG நீற்_GEM_MID நு_BEG நு_BEG-x நு_MID நு_MID-x நுக்_BEG நுட்_BEG நுட்_MID நுண்_BEG நூ_BEG நூ_BEG-x நூ_MID நூ_MID-x நூத்_MID நூல்_BEG நூல்_END நூற்_GEM_BEG நூற்_GEM_MID நெ_BEG நெ_BEG-x நெ_MID நெஞ்_BEG நெஞ்_MID நெட்_BEG நெட்_END நெத்_BEG நெய்_BEG நெல்_BEG நெல்_MID நெற்_GEM_BEG நெஸ்ட்_END நே_BEG நே_BEG-x நே_MID நே_MID-x நேக்_BEG நேக்_MID நேஞ்_BEG நேட்_BEG நேய்_BEG நேர்_BEG நேர்_END நேர்த்_BEG நேர்ந்_BEG நேற்_GEM_BEG நை_BEG நை_BEG-x நை_MID நைல்_BEG நைன்_BEG நொ_BEG நொ_MID நொ_MID-x நொச்_BEG நோ_BEG நோ_BEG-x நோ_MID நோக்_BEG நோக்_MID நோஞ்_BEG நோட்_BEG நோட்ஸ்_BEG நோம்_BEG நோய்_BEG நோய்_END நோய்த்_BEG நௌ_BEG ப்_BEG ப்_END ப்_MID ப_uv_BEG ப_uv_BEG-x ப_uv_END ப_uv_END-x ப_uv_MID ப_uv_MID-x ப_uvக்_BEG ப_uvக்_MID ப_uvங்_BEG ப_uvங்_MID ப_uvச்_BEG ப_uvச்_END ப_uvச்_MID ப_uvஞ்_BEG ப_uvட்_BEG ப_uvட்_MID ப_uvண்_BEG ப_uvண்_END ப_uvத்_BEG ப_uvத்_MID ப_uvந்_BEG ப_uvந்_MID ப_uvப்_MID ப_uvம்_BEG ப_uvம்_END ப_uvம்_MID ப_uvர்_BEG ப_uvர்_END ப_uvர்_MID ப_uvர்க்_END ப_uvல்_BEG ப_uvல்_END ப_uvல்_MID ப_uvவ்_BEG ப_uvள்_BEG ப_uvள்_MID ப_uvற்_BEG ப_uvற்_GEM_BEG ப_uvற்_GEM_MID ப_uvன்_BEG ப_uvன்_END ப_uvன்_MID ப_uvஜ்_BEG ப_uvஸ்_BEG ப_v_END ப_v_END-x ப_v_MID ப_v_MID-x ப_vக்_END ப_vக்_MID ப_vங்_MID ப_vட்_END ப_vட்_MID ப_vண்_MID ப_vத்_END ப_vத்_MID ப_vந்_MID ப_vப்_MID ப_vம்_END ப_vர்_END ப_vர்_MID ப_vர்க்_END ப_vர்ட்_END ப_vர்ட்_MID ப_vர்ந்_MID ப_vல்_END ப_vல்_MID ப_vல்ஸ்_END ப_vள்_MID ப_vற்_GEM_MID ப_vன்_END ப_vன்_MID ப_vன்ஸ்_END ப_vஸ்_END பா_uv_BEG பா_uv_BEG-x பா_uv_END பா_uv_END-x பா_uv_MID பா_uv_MID-x பா_uvக்_BEG பா_uvக்_MID பா_uvங்_BEG பா_uvஞ்_BEG பா_uvஞ்_MID பா_uvட்_BEG பா_uvட்_MID பா_uvட்ஸ்_BEG பா_uvண்_BEG பா_uvண்ட்_BEG பா_uvத்_BEG பா_uvத்_MID பா_uvந்_BEG பா_uvப்_BEG பா_uvம்_BEG பா_uvம்_MID பா_uvய்_BEG பா_uvய்_END பா_uvய்_MID பா_uvய்க்_BEG பா_uvய்ச்_BEG பா_uvய்ந்_BEG பா_uvய்ந்_MID பா_uvர்_BEG பா_uvர்_END பா_uvர்_MID பா_uvர்க்_BEG பா_uvர்க்ஸ்_BEG பா_uvர்த்_BEG பா_uvர்த்_MID பா_uvர்ப்_BEG பா_uvல்_BEG பா_uvல்_END பா_uvழ்_BEG பா_uvள்_END பா_uvற்_BEG பா_uvற்_GEM_MID பா_uvன்_BEG பா_uvன்_END பா_uvன்_MID பா_uvஸ்_BEG பா_uvஸ்_MID பா_uvஸ்ட்_BEG பா_v_END பா_v_END-x பா_v_MID பா_v_MID-x பா_vட்_END பா_vட்_MID பா_vண்_MID பா_vத்_END பா_vத்_MID பா_vய்_END பா_vய்_MID பா_vய்க்_MID பா_vர்_END பா_vர்_MID பா_vர்க்_MID பா_vர்த்_MID பா_vல்_END பா_vற்_END பா_vன்_END பா_vன்_MID பா_vஜ்_END பா_vஸ்_MID பி_uv_BEG பி_uv_BEG-x பி_uv_END பி_uv_END-x பி_uv_MID பி_uv_MID-x பி_uvக்_BEG பி_uvக்_MID பி_uvச்_BEG பி_uvச்_END பி_uvஞ்_BEG பி_uvஞ்ச்_BEG பி_uvட்_MID பி_uvண்_BEG பி_uvத்_BEG பி_uvத்_END பி_uvத்_MID பி_uvந்_BEG பி_uvப்_BEG பி_uvப்_END பி_uvம்_MID பி_uvல்_BEG பி_uvல்_END பி_uvள்_BEG பி_uvள்_END பி_uvள்_MID பி_uvற்_BEG பி_uvற்_MID பி_uvன்_BEG பி_uvன்_END பி_uvன்_MID பி_uvஸ்_BEG பி_v_END பி_v_END-x பி_v_MID பி_v_MID-x பி_vக்_END பி_vக்_MID பி_vச்_END பி_vச்_MID பி_vட்_END பி_vத்_MID பி_vப்_MID பி_vல்_END பி_vல்_MID பி_vள்_END பி_vள்ஸ்_END பி_vன்_END பி_vன்_MID பி_vஸ்_END பி_vஸ்_MID பீ_uv_BEG பீ_uv_BEG-x பீ_uv_MID பீ_uvச்_BEG பீ_uvட்_BEG பீ_uvட்_MID பீ_uvத்_BEG பீ_uvப்_BEG பீ_uvர்_BEG பீ_uvர்_MID பீ_uvல்_MID பீ_uvன்ஸ்_BEG பீ_uvஷ்_BEG பீ_uvஸ்_END பீ_v_MID பீ_v_MID-x பீ_vட்_MID பீ_vப்_END பு_uv_BEG பு_uv_BEG-x பு_uv_END பு_uv_END-x பு_uv_MID பு_uv_MID-x பு_uvக்_END பு_uvக்_MID பு_uvங்_MID பு_uvச்_END பு_uvட்_MID பு_uvண்_BEG பு_uvத்_BEG பு_uvத்_END பு_uvத்_MID பு_uvப்_END பு_uvம்_END பு_uvம்_MID பு_uvல்_BEG பு_uvல்_END பு_uvல்_MID பு_uvள்_BEG பு_uvள்_END பு_uvள்_MID பு_uvற்_GEM_BEG பு_uvற்_GEM_MID பு_uvன்_BEG பு_uvஷ்_BEG பு_v_END பு_v_END-x பு_v_MID பு_v_MID-x பு_vக்_END பு_vக்_MID பு_vச்_END பு_vச்_MID பு_vண்_END பு_vத்_END பு_vத்_MID பு_vப்_END பு_vம்_END பு_vம்_MID பு_vள்_MID பு_vற்_MID பூ_uv_BEG பூ_uv_BEG-x பூ_uv_END பூ_uv_MID பூ_uv_MID-x பூ_uvக்_BEG பூ_uvக்_MID பூ_uvங்_BEG பூ_uvச்_BEG பூ_uvட்ஸ்_BEG பூ_uvண்_BEG பூ_uvத்_BEG பூ_uvத்_MID பூ_uvந்_BEG பூ_uvப்_BEG பூ_uvம்_BEG பூ_uvர்_BEG பூ_uvர்_END பூ_uvர்_MID பூ_uvர்ஷ்_BEG பூ_uvன்_END பூ_v_END பூ_v_MID பூ_v_MID-x பூ_vர்_END பூ_vர்_MID பூ_vல்_END பூ_vன்_END பெ_uv_BEG பெ_uv_BEG-x பெ_uv_MID பெ_uv_MID-x பெ_uvக்_MID பெ_uvங்_BEG பெ_uvஞ்_BEG பெ_uvட்_BEG பெ_uvண்_BEG பெ_uvண்_END பெ_uvண்_MID பெ_uvப்_BEG பெ_uvம்_BEG பெ_uvய்_BEG பெ_uvர்_BEG பெ_uvர்ட்_BEG பெ_uvல்_BEG பெ_uvல்_END பெ_uvல்ட்_BEG பெ_uvற்_GEM_BEG பெ_uvற்_GEM_MID பெ_uvன்_BEG பெ_uvன்_MID பெ_uvன்ஸ்_BEG பெ_v_MID பெ_v_MID-x பெ_vட்_END பெ_vட்ஸ்_END பெ_vண்_MID பெ_vத்_END பெ_vய்_MID பெ_vல்_MID பெ_vற்_GEM_MID பெ_vஸ்_END பே_uv_BEG பே_uv_BEG-x பே_uv_END பே_uv_END-x பே_uv_MID பே_uv_MID-x பே_uvச்_BEG பே_uvட்_BEG பே_uvப்_BEG பே_uvய்_BEG பே_uvர்_BEG பே_uvர்_END பே_uvர்ப்_MID பே_uvற்_GEM_MID பே_uvன்_BEG பே_uvன்_END பே_v_END பே_v_END-x பே_v_MID பே_v_MID-x பே_vட்_MID பே_vத்_MID பே_vந்_MID பே_vர்_END பே_vர்_MID பை_uv_BEG பை_uv_BEG-x பை_uv_END பை_uv_END-x பை_uv_MID பை_uv_MID-x பை_uvக்_BEG பை_uvங்_BEG பை_uvச்_END பை_uvத்_BEG பை_uvத்_MID பை_uvப்_END பை_uvப்_MID பை_uvர்_END பை_uvல்_BEG பை_v_END பை_v_END-x பை_v_MID பை_v_MID-x பை_vக்_MID பொ_uv_BEG பொ_uv_BEG-x பொ_uv_MID பொ_uv_MID-x பொ_uvக்_BEG பொ_uvங்_BEG பொ_uvட்_BEG பொ_uvண்_BEG பொ_uvம்_BEG பொ_uvய்_BEG பொ_uvய்க்_BEG பொ_uvல்_BEG பொ_uvற்_BEG பொ_uvன்_BEG பொ_uvன்_MID பொ_v_MID பொ_v_MID-x பொ_vம்_MID பொ_vய்_END பொ_vல்_MID போ_uv_BEG போ_uv_BEG-x போ_uv_END போ_uv_END-x போ_uv_MID போ_uv_MID-x போ_uvக்_BEG போ_uvக்_MID போ_uvச்_BEG போ_uvட்_BEG போ_uvட்_MID போ_uvப்_BEG போ_uvம்_END போ_uvய்_BEG போ_uvய்_END போ_uvய்க்_BEG போ_uvய்த்_BEG போ_uvர்_BEG போ_uvர்_END போ_uvர்க்_BEG போ_uvர்க்_END போ_uvர்ட்_END போ_uvர்ட்_MID போ_uvர்த்_BEG போ_uvல்_BEG போ_uvல்_END போ_uvற்_GEM_BEG போ_uvன்_BEG போ_uvஸ்_END போ_uvஸ்ட்_BEG போ_v_END போ_v_END-x போ_v_MID போ_v_MID-x போ_vக்_END போ_vக்_MID போ_vம்_END போ_vய்_END போ_vர்_END போ_vர்_MID போ_vல்_END போ_vல்_MID போ_vல்ஸ்க்_END போ_vன்_END போ_vன்_MID போ_vஸ்_END பௌ_uv_BEG பௌ_uvர்_BEG பௌ_v_MID பௌ_v_MID-x ப்ர_BEG ப்ரட்_BEG ப்ரப்_BEG ப்ரா_BEG ப்ராக்_BEG ப்ரி_BEG ப்ரிட்_BEG ப்ரை_BEG ப்ரைட்_BEG ப்ளஸ்_BEG ப்ளாங்_BEG ப்ளாட்_BEG ப்ளாஸ்_BEG ப்ளீ_BEG ப்ளூ_BEG ம்_BEG ம்_END ம்_MID ம_BEG ம_BEG-x ம_END ம_END-x ம_MID ம_MID-x மக்_BEG மக்_MID மங்_BEG மங்_MID மச்_BEG மச்_MID மஞ்_BEG மட்_BEG மட்_MID மண்_BEG மண்_MID மண்ட்_BEG மண்ட்_END மத்_BEG மத்_END மத்_MID மந்_BEG மந்_MID மப்_MID மம்_END மம்_MID மர்_BEG மர்_END மர்_MID மர்க்_MID மர்ச்_MID மர்த்_BEG மர்த்_END மர்த்_MID மர்ந்_MID மர்ப்_MID மல்_BEG மல்_END மல்_MID மல்ட்_BEG மழ்_MID மற்_BEG மற்_END மற்_GEM_BEG மற்_GEM_MID மன்_BEG மன்_END மன்_MID மஸ்_END மஸ்_MID மஹ்_BEG மா_BEG மா_BEG-x மா_END மா_END-x மா_MID மா_MID-x மாக்_BEG மாக்_MID மாக்ஸ்_BEG மாங்_BEG மாஞ்_BEG மாஞ்_MID மாட்_BEG மாட்_MID மாண்_BEG மாண்_MID மாத்_BEG மாத்_MID மாந்_BEG மாந்_MID மாப்_BEG மாப்_MID மாம்_BEG மாம்_END மாய்_BEG மாய்_END மாய்_MID மாய்த்_BEG மாய்த்_MID மாய்ப்_BEG மாய்ப்_END மார்_BEG மார்_END மார்க்_BEG மார்க்_MID மார்க்ஸ்_BEG மார்ச்_BEG மார்ட்_BEG மார்ட்_END மார்த்_MID மால்_END மாள்_END மாற்_END மாற்_GEM_BEG மாற்_GEM_MID மான்_BEG மான்_END மான்_MID மாஜ்_MID மாஸ்_BEG மாஸ்ட்_BEG மி_BEG மி_BEG-x மி_END மி_END-x மி_MID மி_MID-x மிக்_BEG மிக்_END மிக்_MID மிங்_MID மிச்_BEG மிச்_MID மிஞ்_BEG மிட்_BEG மிட்_MID மித்_BEG மித்_MID மிந்_BEG மிப்_MID மிர்_BEG மிர்_END மிர்_MID மில்_BEG மில்_END மில்_MID மிழ்_END மிழ்_MID மிழ்க்_END மிழ்ச்_END மிழ்த்_END மிழ்ந்_MID மிழ்ன்_MID மின்_BEG மின்_END மின்_MID மிஸ்_BEG மீ_BEG மீ_BEG-x மீ_MID மீ_MID-x மீட்_BEG மீட்_MID மீண்_BEG மீம்_END மீர்_END மீன்_BEG மீன்_END மீன்_MID மீஸ்_END மு_BEG மு_BEG-x மு_END மு_END-x மு_MID மு_MID-x முக்_BEG முக்_MID முங்_MID முட்_BEG முத்_BEG முத்_MID முந்_BEG முந்_MID முப்_BEG மும்_BEG மும்_END முல்_BEG முல்க்_END முழ்_BEG முள்_BEG முள்_MID முற்_BEG முற்_GEM_BEG முற்_GEM_MID முன்_BEG முன்_END முன்_MID முஸ்_BEG முஸ்_MID மூ_BEG மூ_BEG-x மூ_END மூ_MID மூ_MID-x மூக்_BEG மூக்_MID மூங்_BEG மூச்_BEG மூச்_MID மூஞ்_BEG மூட்_BEG மூட்_MID மூண்_BEG மூத்_BEG மூத்_END மூர்ச்_BEG மூர்த்_BEG மூர்த்_MID மூழ்_BEG மூன்_BEG மூன்_MID மெ_BEG மெ_BEG-x மெ_MID மெ_MID-x மெக்_BEG மெச்_BEG மெத்_BEG மெத்_MID மெம்_BEG மெம்_MID மெய்_BEG மெய்_END மெய்_MID மெய்த்_BEG மெய்ப்_BEG மெய்ம்_BEG மெர்க்_BEG மெல்_BEG மெல்_MID மென்_BEG மென்_END மென்_MID மே_BEG மே_BEG-x மே_END மே_END-x மே_MID மே_MID-x மேக்ஸ்_BEG மேட்_BEG மேட்_END மேட்_MID மேத்_BEG மேம்_BEG மேய்க்_BEG மேய்ந்_BEG மேல்_BEG மேல்_END மேல்_MID மேற்_BEG மேற்_GEM_BEG மேற்_GEM_MID மேன்_BEG மேன்_END மேஷ்_END மேஸ்_MID மை_BEG மை_BEG-x மை_END மை_END-x மை_MID மை_MID-x மைக்_BEG மைக்_END மைக்_MID மைச்_MID மைத்_BEG மைத்_END மைத்_MID மைந்_BEG மைந்_MID மைப்_END மைப்_MID மைய்_BEG மைல்_BEG மைல்_MID மைன்_END மொ_BEG மொ_BEG-x மொ_MID மொ_MID-x மொக்_BEG மொட்_BEG மொத்_BEG மொத்_MID மொன்_MID மோ_BEG மோ_BEG-x மோ_END மோ_END-x மோ_MID மோ_MID-x மோட்_BEG மோட்_END மோத்_MID மோந்_MID மோர்_BEG மோல்_BEG மோன்_BEG மௌ_BEG மௌ_BEG-x ம்மே_BEG ய்_END ய்_MID ய_BEG ய_BEG-x ய_END ய_END-x ய_MID ய_MID-x யக்_BEG யக்_END யக்_MID யங்_MID யச்_END யச்_MID யட்_BEG யட்_END யட்_MID யண்_END யத்_END யத்_MID யந்_MID யப்_END யப்_MID யம்_END யம்_MID யர்_END யர்_MID யர்க்_MID யர்த்_MID யர்ந்_MID யர்ப்_MID யர்ஜ்_END யர்ஸ்_END யல்_END யல்_MID யல்ச்_END யள்_END யற்_GEM_MID யற்_MID யன்_BEG யன்_END யன்_MID யன்ஸ்_END யஸ்_END யா_BEG யா_BEG-x யா_END யா_END-x யா_MID யா_MID-x யாக்_MID யாங்_BEG யாங்_END யாங்_MID யாட்_MID யாண்_MID யாத்_END யாத்_MID யாந்_MID யாய்_END யாய்க்_END யாய்ப்_END யார்_BEG யார்_END யார்_MID யால்_END யால்_MID யாள்_END யாற்_GEM_MID யான்_BEG யான்_END யான்_MID யாஸ்_END யி_BEG யி_END யி_MID யி_MID-x யிக்_MID யிங்_END யிட்_MID யிம்_END யிர்_END யிர்_MID யிர்த்_MID யிர்ப்_MID யில்_END யில்_MID யிற்_END யிற்_GEM_MID யிற்_MID யின்_END யின்_MID யிஸ்_END யிஸ்_MID யிஸ்ட்_END யீ_MID யீட்_MID யீர்ப்_MID யீஸ்_MID யு_BEG யு_BEG-x யு_END யு_END-x யு_MID யு_MID-x யுக்_MID யுங்_MID யுச்_MID யுட்_MID யுண்_MID யுத்_BEG யுத்_MID யுந்_MID யுப்_END யும்_END யும்_MID யுர்_MID யுள்_END யுள்_MID யுற்_GEM_MID யூ_BEG யூ_BEG-x யூ_END யூ_END-x யூ_MID யூ_MID-x யூக்_BEG யூட்_MID யூப்_BEG யூப்_END யூர்_END யூல்_END யூஷ்_END யூஸ்_END யூஸ்ட்_END யெ_BEG யெ_END யெ_END-x யெ_MID யெ_MID-x யெக்_BEG யெட்_MID யெத்_END யெல்_MID யெவ்_END யெவ்_MID யென்_MID யே_BEG யே_END யே_END-x யே_MID யே_MID-x யேச்_MID யேட்_MID யேந்_MID யேல்_END யேவ்ஸ்_MID யேற்_GEM_MID யேன்_END யை_END யை_END-x யை_MID யை_MID-x யைக்_END யைக்_MID யைச்_END யைத்_END யைத்_MID யைப்_END யொ_BEG யொ_MID யொ_MID-x யொட்_MID யொத்_BEG யொத்_MID யொப்_MID யோ_BEG யோ_BEG-x யோ_END யோ_END-x யோ_MID யோ_MID-x யோக்_BEG யோக்_END யோக்_MID யோங்_END யோட்_MID யோத்_BEG யோத்_MID யோப்_MID யோர்_END யோர்_MID யோல்_END யௌ_BEG யௌ_MID யௌ_MID-x ர்_END ர்_MID ர_BEG ர_BEG-x ர_END ர_END-x ர_MID ர_MID-x ரக்_END ரக்_MID ரக்ட்_END ரங்_BEG ரங்_MID ரச்_END ரச்_MID ரஞ்_MID ரஞ்ச்_END ரட்_END ரட்_MID ரண்_BEG ரண்_END ரண்_MID ரண்ட்_END ரத்_BEG ரத்_END ரத்_MID ரந்_MID ரப்_BEG ரப்_END ரப்_MID ரம்_BEG ரம்_END ரம்_MID ரம்ஸ்_BEG ரர்_END ரர்_MID ரல்_END ரல்_MID ரள்_END ரற்_GEM_MID ரன்_BEG ரன்_END ரன்_MID ரன்ட்_END ரஷ்_BEG ரஸ்_BEG ரஸ்_END ரஸ்_MID ரஹ்_BEG ரா_BEG ரா_BEG-x ரா_END ரா_END-x ரா_MID ரா_MID-x ராக்_BEG ராக்_END ராக்_MID ராக்ட்_MID ராச்_MID ராட்_BEG ராட்_MID ராத்_BEG ராத்_END ராத்_MID ராந்_MID ராப்_BEG ராப்_END ராப்_MID ராம்_BEG ராம்_END ராம்_MID ராய்_END ராய்ச்_MID ராய்ட்_MID ராய்ந்_MID ராய்ப்_BEG ரார்_END ரார்த்_MID ரால்_END ரால்ட்_END ராவ்_BEG ராவ்_END ராவ்_MID ரான்_END ரான்_MID ராஜ்_BEG ராஜ்_END ராஜ்_MID ராஷ்_MID ராஷ்ட்_MID ராஸ்_BEG ராஸ்_END ராஹ்_MID ரி_BEG ரி_BEG-x ரி_END ரி_END-x ரி_MID ரி_MID-x ரிக்_BEG ரிக்_END ரிக்_MID ரிக்ஸ்_END ரிங்_BEG ரிச்_BEG ரிச்_END ரிச்_MID ரிஞ்_MID ரிட்_BEG ரிட்_END ரிட்_MID ரிண்_MID ரித்_END ரித்_MID ரிந்_MID ரிப்_END ரிப்_MID ரிர்_MID ரில்_END ரில்_MID ரின்_END ரின்_MID ரின்ஸ்_END ரிஸ்_END ரிஸ்_MID ரீ_END ரீ_END-x ரீ_MID ரீ_MID-x ரீங்_BEG ரீச்_MID ரீட்_BEG ரீட்_MID ரீட்ஸ்_END ரீம்_END ரீன்_END ரீஸ்_BEG ரீஸ்_END ரு_BEG ரு_BEG-x ரு_END ரு_END-x ரு_MID ரு_MID-x ருக்_MID ருங்_MID ருச்_MID ருஞ்_MID ருட்_END ருட்_MID ருண்_MID ருத்_MID ருத்ப்_MID ருந்_MID ருப்_END ருப்_MID ரும்_END ரும்_MID ருல்_END ருள்_END ருள்_MID ருஷ்_MID ருஸ்_BEG ரூ_BEG ரூ_BEG-x ரூ_END ரூ_MID ரூ_MID-x ரூக்_MID ரூட்_END ரூட்_MID ரூப்_END ரூம்_BEG ரூம்_END ரூர்_END ரூர்_MID ரூல்_BEG ரூல்_MID ரூன்_END ரூஸ்_BEG ரெ_BEG ரெ_BEG-x ரெ_MID ரெ_MID-x ரெக்_BEG ரெட்_BEG ரெட்_END ரெண்_BEG ரெண்_MID ரெண்ட்_END ரெத்_MID ரெப்_BEG ரெல்_MID ரென்_MID ரெஷ்_END ரே_BEG ரே_BEG-x ரே_END ரே_END-x ரே_MID ரே_MID-x ரேக்_MID ரேங்க்_BEG ரேட்_END ரேட்_MID ரேந்_MID ரேப்_END ரேய்_BEG ரேன்_END ரேஷ்_MID ரேஸ்_BEG ரேஸ்_MID ரை_BEG ரை_END ரை_END-x ரை_MID ரை_MID-x ரைக்_END ரைக்_MID ரைச்_END ரைச்_MID ரைட்_BEG ரைட்ஸ்_END ரைத்_END ரைத்_MID ரைந்_MID ரைப்_END ரைப்_MID ரைன்_BEG ரைஸ்_BEG ரொ_BEG ரொ_MID ரொ_MID-x ரொட்_BEG ரொம்_BEG ரொவ்_MID ரோ_BEG ரோ_BEG-x ரோ_END ரோ_END-x ரோ_MID ரோ_MID-x ரோக்_MID ரோட்_END ரோட்_MID ரோப்_MID ரோல்_END ரோன்_MID ரோஜ்_END ரோஸ்_END ரோஸ்_MID ரௌ_MID ரௌத்_BEG ரக்ஷ்_END ல்_BEG ல்_END ல்_MID ல_BEG ல_BEG-x ல_END ல_END-x ல_MID ல_MID-x லக்_BEG லக்_END லக்_MID லங்_MID லஞ்_BEG லஞ்_MID லட்_BEG லட்_MID லண்_MID லத்_END லத்_MID லந்_MID லப்_BEG லப்_END லப்_MID லம்_END லம்_MID லர்_END லர்_MID லர்ந்_MID லர்ப்_END லவ்_END லற்_MID லன்_END லன்_MID லன்ட்ஸ்_END லஷ்_MID லஸ்_END லஸ்ட்_MID லா_BEG லா_BEG-x லா_END லா_END-x லா_MID லா_MID-x லாக்_BEG லாக்_END லாக்_MID லாங்_MID லாச்_END லாச்_MID லாஞ்_BEG லாட்_END லாட்_MID லாத்_END லாத்_MID லாந்_MID லாந்த்_END லாப்_END லாப்_MID லாம்_END லாம்_MID லாய்_END லாய்_MID லார்_END லால்_END லாவ்_END லாற்_GEM_MID லான்_MID லாஸ்_BEG லாஸ்_END லாஸ்_MID லாஹ்_END லி_BEG லி_BEG-x லி_END லி_END-x லி_MID லி_MID-x லிக்_END லிக்_MID லிங்_BEG லிங்க்_END லிச்_END லிச்_MID லிஞ்_END லிட்_BEG லிட்_END லிட்_MID லிண்_BEG லித்_END லித்_MID லிந்_MID லிப்_BEG லிப்_END லிப்_MID லிம்_MID லிர்க்_MID லிர்ப்_MID லில்_END லில்_MID லிவ்_BEG லிவ்_END லிற்_END லிற்_GEM_MID லின்_BEG லின்_END லின்_MID லின்ஸ்_END லின்ஸ்_MID லிஸ்ட்_MID லீ_BEG லீ_BEG-x லீ_END லீ_MID லீ_MID-x லீம்_END லீர்_MID லீஸ்_END லீஸ்_MID லு_BEG லு_END லு_END-x லு_MID லு_MID-x லுக்_BEG லுக்_MID லுங்_MID லுத்_MID லுப்_MID லும்_END லும்_MID லுள்_MID லுஸ்_MID லூ_BEG லூ_BEG-x லூ_MID லூ_MID-x லூக்_MID லூச்_END லூர்_END லூன்_MID லெ_BEG லெ_BEG-x லெ_END லெ_MID லெ_MID-x லெக்_MID லெங்_MID லெச்_MID லெட்_END லெண்_MID லெப்_BEG லெய்ப்_BEG லெல்_MID லெஸ்_BEG லெஸ்_MID லே_BEG லே_BEG-x லே_END லே_END-x லே_MID லே_MID-x லேட்_MID லேந்_MID லேப்_BEG லேன்_END லேன்ஸ்_BEG லேஸ்_BEG லேஸ்_MID லை_BEG லை_END லை_END-x லை_MID லை_MID-x லைக்_END லைக்_MID லைச்_END லைச்_MID லைட்_BEG லைட்_END லைத்_END லைத்_MID லைந்_MID லைப்_BEG லைப்_END லைப்_MID லைன்_BEG லைன்ட்_END லைன்ஸ்_BEG லொ_BEG லொ_MID லொ_MID-x லொள்_BEG லோ_BEG லோ_BEG-x லோ_END லோ_END-x லோ_MID லோ_MID-x லோட்_BEG லோட்_MID லோத்_MID லோர்_END லோல்_END லௌ_BEG வ்_BEG வ்_END வ்_MID வ_BEG வ_BEG-x வ_END வ_END-x வ_MID வ_MID-x வக்_BEG வக்_END வக்_MID வங்_BEG வங்_MID வச்_BEG வச்_END வஞ்_BEG வஞ்_MID வட்_BEG வட்_MID வண்_BEG வண்_MID வத்_MID வந்_BEG வந்_MID வந்த்_END வந்த்_MID வப்_END வப்_MID வம்_BEG வம்_END வம்_MID வர்_BEG வர்_END வர்_MID வர்க்_BEG வர்க்_MID வர்ச்_MID வர்த்_BEG வர்த்_MID வர்ந்_MID வர்ஸ்_MID வல்_BEG வல்_END வல்_MID வள்_END வள்_MID வற்_BEG வற்_GEM_BEG வற்_GEM_MID வற்_MID வன்_BEG வன்_END வன்_MID வஸ்_BEG வஸ்_MID வஸ்ட்_MID வா_BEG வா_BEG-x வா_END வா_END-x வா_MID வா_MID-x வாக்_BEG வாக்_END வாக்_MID வாக்ஸ்_END வாங்_BEG வாங்_MID வாச்_BEG வாஞ்_BEG வாட்_BEG வாட்_END வாட்_MID வாண்_BEG வாண்_MID வாத்_BEG வாந்_BEG வாந்_MID வாப்_BEG வாப்_MID வாம்_MID வாய்_BEG வாய்_END வாய்_MID வாய்க்_BEG வாய்ச்_BEG வாய்ந்_BEG வாய்ந்_MID வாய்ப்_BEG வாய்ப்_END வாய்ஸ்_BEG வார்_BEG வார்_END வார்_MID வார்க்_MID வார்த்_BEG வார்த்_MID வார்ப்_END வால்_BEG வால்_END வால்_MID வால்ட்_BEG வால்ட்_END வாவ்_BEG வாழ்_BEG வாழ்_MID வாழ்க்_BEG வாழ்த்_BEG வாழ்ந்_BEG வாள்_BEG வாள்_END வாள்_MID வான்_BEG வான்_END வான்_MID வாஜ்_END வாஸ்_END வி_BEG வி_BEG-x வி_END வி_END-x வி_MID வி_MID-x விக்_BEG விக்_END விக்_MID விச்_END விஞ்_BEG விட்_BEG விட்_MID விண்_BEG விண்_MID வித்_BEG வித்_MID விந்_BEG விந்_END விந்_MID விப்_END விப்_MID விம்_BEG விர்_END விர்_MID விர்க்_MID விர்த்_MID வில்_BEG வில்_END வில்_MID விழ்க்_MID விழ்த்_MID விழ்ந்_MID விழ்ப்_MID விள்_BEG விற்_BEG விற்_END விற்_GEM_BEG விற்_MID விற்க்_MID வின்_BEG வின்_END வின்_MID விஷ்_BEG விஷ்_MID விஸ்_BEG வீ_BEG வீ_BEG-x வீ_MID வீ_MID-x வீச்_BEG வீச்_MID வீட்_BEG வீட்_MID வீண்_BEG வீர்_BEG வீர்_END வீர்_MID வீல்_BEG வீழ்_BEG வீழ்ச்_BEG வீழ்ச்_MID வீழ்த்_BEG வீழ்ந்_BEG வீற்_GEM_BEG வு_BEG வு_END வு_END-x வு_MID வு_MID-x வுக்_BEG வுக்_END வுக்_MID வுச்_MID வுட்_END வுண்_MID வுண்ட்_MID வுத்_END வுத்_MID வுப்_END வுப்_MID வும்_END வும்_MID வுர்_MID வுள்_END வுள்_MID வுன்_MID வூ_BEG வூ_BEG-x வூ_MID வூ_MID-x வூட்_MID வூத்_END வூர்_END வூர்_MID வெ_BEG வெ_BEG-x வெ_MID வெ_MID-x வெங்_BEG வெச்_BEG வெட்_BEG வெட்_MID வெண்_BEG வெந்_BEG வெப்_BEG வெய்_BEG வெர்ப்_END வெல்_BEG வெல்_MID வெல்ட்_END வெல்ட்_MID வெவ்_BEG வெள்_BEG வெற்_GEM_BEG வென்_BEG வென்_MID வென்ட்_BEG வெஜ்_BEG வே_BEG வே_BEG-x வே_END வே_END-x வே_MID வே_MID-x வேட்_BEG வேட்_MID வேண்_BEG வேண்_MID வேந்_BEG வேந்_MID வேப்_BEG வேப்_MID வேம்_BEG வேய்ந்_BEG வேர்_BEG வேர்_END வேர்_MID வேர்ட்_BEG வேல்_BEG வேவ்_END வேள்_BEG வேற்_GEM_BEG வேற்_GEM_MID வேற்_MID வேன்_BEG வேன்_END வேன்_MID வேஸ்_END வை_BEG வை_BEG-x வை_END வை_END-x வை_MID வை_MID-x வைக்_BEG வைக்_END வைக்_MID வைச்_BEG வைத்_BEG வைத்_END வைத்_MID வைப்_BEG வைப்_END வைப்_MID வைஷ்_BEG வைஷ்_MID வைஸ்_END வொ_BEG வொ_MID வொ_MID-x வொர்_END வொர்க்_END வொன்_MID வொஸ்க்_MID வோ_BEG வோ_END வோ_END-x வோ_MID வோ_MID-x வோக்_END வோம்_END வோர்_END வோர்_MID வோல்ஸ்_BEG வௌ_BEG ழ_BEG ழ_END ழ_END-x ழ_MID ழ_MID-x ழக்_END ழக்_MID ழங்_MID ழச்_END ழச்_MID ழஞ்_MID ழட்_MID ழண்_MID ழத்_END ழத்_MID ழந்_MID ழப்_END ழப்_MID ழம்_END ழம்_MID ழர்_END ழர்_MID ழல்_END ழல்_MID ழற்_GEM_MID ழற்_MID ழன்_END ழன்_MID ழ்_END ழ்_MID ழா_BEG ழா_END ழா_END-x ழா_MID ழா_MID-x ழாங்_MID ழாம்_END ழாம்_MID ழாய்_MID ழார்_MID ழி_END ழி_END-x ழி_MID ழி_MID-x ழிக்_END ழிக்_MID ழிஞ்_MID ழித்_MID ழிந்_MID ழிப்_END ழிப்_MID ழில்_END ழில்_MID ழிற்_MID ழீ_BEG ழீ_MID ழீஸ்_MID ழு_END ழு_END-x ழு_MID ழு_MID-x ழுக்_MID ழுங்_MID ழுத்_MID ழுந்_MID ழுப்_MID ழும்_END ழும்_MID ழுள்_MID ழூ_MID ழூ_MID-x ழெ_MID ழெட்_MID ழென்_MID ழே_END ழே_END-x ழே_MID ழேந்_MID ழை_END ழை_END-x ழை_MID ழை_MID-x ழைக்_END ழைக்_MID ழைச்_END ழைச்_MID ழைத்_MID ழைந்_MID ழைப்_END ழைப்_MID ழொ_MID ழோ_END ழோ_MID ழோர்_END ள்_END ள்_MID ள_END ள_END-x ள_MID ள_MID-x ளக்_MID ளங்_MID ளச்_END ளச்_MID ளஞ்_MID ளட்_MID ளத்_END ளத்_MID ளந்_MID ளப்_END ளப்_MID ளம்_END ளம்_MID ளர்_END ளர்_MID ளர்க்_MID ளர்ச்_MID ளர்த்_MID ளர்ந்_MID ளர்ப்_MID ளல்_END ளன்_END ளன்_MID ளா_END ளா_END-x ளா_MID ளா_MID-x ளாக்_END ளாக்_MID ளாண்_END ளாண்_MID ளாத்_END ளாத்_MID ளாம்_END ளாம்_MID ளாய்_END ளாய்த்_END ளார்_END ளார்_MID ளால்_END ளான்_END ளாஸ்_END ளி_END ளி_END-x ளி_MID ளி_MID-x ளிக்_END ளிக்_MID ளிங்_MID ளிச்_END ளிச்_MID ளிட்_END ளிட்_MID ளிட்ஸ்_END ளித்_END ளித்_MID ளிந்_MID ளிப்_END ளிப்_MID ளிம்_MID ளிர்_END ளிர்_MID ளிர்த்_MID ளிர்ந்_MID ளில்_END ளில்_MID ளிள்_END ளிற்_END ளின்_END ளின்_MID ளீ_BEG ளீ_MID ளீர்_END ளீர்_MID ளு_END ளு_END-x ளு_MID ளு_MID-x ளுக்_MID ளுங்_MID ளுத்_MID ளுந்_MID ளும்_END ளும்_MID ளுர்த்_END ளுள்_END ளூ_MID ளூ_MID-x ளூக்_MID ளூம்_END ளூர்_END ளூர்க்_MID ளெ_MID ளெ_MID-x ளெல்_MID ளே_END ளே_END-x ளே_MID ளே_MID-x ளேன்_END ளை_END ளை_END-x ளை_MID ளை_MID-x ளைக்_END ளைக்_MID ளைங்_MID ளைச்_END ளைச்_MID ளைத்_END ளைத்_MID ளைந்_MID ளைப்_END ளைப்_MID ளொ_MID ளொ_MID-x ளொன்_MID ளோ_END ளோ_END-x ளோ_MID ளோ_MID-x ளோங்_MID ளோம்_END ளோர்_END ற்_END ற்_GEM_MID ற்_MID ற_BEG ற_END ற_END-x ற_GEM_END ற_GEM_END-x ற_GEM_MID ற_GEM_MID-x ற_GEMக்_END ற_GEMங்_MID ற_GEMச்_END ற_GEMச்_MID ற_GEMத்_END ற_GEMத்_MID ற_GEMப்_MID ற_GEMம்_END ற_GEMம்_MID ற_GEMர்_MID ற_GEMல்_END ற_GEMன்_END ற_MID ற_MID-x றக்_MID றங்_MID றச்_END றண்_MID றத்_END றத்_MID றந்_MID றப்_END றப்_MID றம்_END றம்_MID றர்_END றர்க்_MID றல்_END றல்_MID றழ்ந்_MID றன்_END றன்_MID றா_BEG றா_END றா_END-x றா_GEM_END றா_GEM_MID றா_GEM_MID-x றா_GEMண்_MID றா_GEMம்_END றா_GEMய்_END றா_GEMர்_END றா_GEMல்_END றா_GEMற்_GEM_END றா_GEMன்_END றா_GEMன்_MID றா_MID றா_MID-x றாக்_MID றாங்_MID றாட்_MID றாண்_MID றாப்_MID றாம்_END றாய்_END றாய்த்_END றார்_END றார்_MID றார்ன்_MID றால்_END றாள்_BEG றாள்_END றான்_END றி_BEG றி_END றி_END-x றி_GEM_END றி_GEM_END-x றி_GEM_MID றி_GEM_MID-x றி_GEMக்_END றி_GEMக்_MID றி_GEMத்_END றி_GEMப்_END றி_GEMல்_END றி_GEMல்_MID றி_GEMற்_GEM_MID றி_GEMன்_END றி_GEMன்_MID றி_MID றி_MID-x றிக்_END றிக்_MID றிங்_MID றிச்_END றிச்_MID றிஞ்_MID றிட்_MID றித்_END றித்_MID றிந்_MID றிப்_END றிப்_MID றில்_END றில்_MID றிற்_GEM_MID றின்_END றீ_MID றீ_MID-x றீங்_MID றீர்_END றீர்_MID று_END று_END-x று_GEM_END று_GEM_END-x று_GEM_MID று_GEM_MID-x று_GEMக்_END று_GEMக்_MID று_GEMச்_END று_GEMச்_MID று_GEMட்_END று_GEMண்_MID று_GEMத்_END று_GEMத்_MID று_GEMப்_END று_GEMப்_MID று_GEMம்_END று_GEMம்_MID று_GEMள்_MID று_MID று_MID-x றுக்_MID றுங்_MID றுஞ்_END றுத்_MID றுந்_MID றுப்_MID றும்_END றும்_MID றூ_GEM_MID றூ_GEM_MID-x றூ_GEMர்_END றெ_GEM_MID றெ_MID றெ_MID-x றெண்_MID றெல்_MID றென்_MID றே_END றே_END-x றே_GEM_END றே_GEM_END-x றே_GEM_MID றே_GEMன்_END றே_MID றே_MID-x றேல்_END றேன்_END றை_BEG றை_END றை_END-x றை_GEM_END றை_GEM_END-x றை_GEM_MID றை_GEM_MID-x றை_GEMக்_END றை_GEMச்_END றை_GEMப்_END றை_GEMம்_MID றை_MID றை_MID-x றைக்_END றைக்_MID றைச்_END றைச்_MID றைத்_END றைத்_MID றைந்_MID றைப்_END றைப்_MID றொ_BEG றொ_GEM_MID றொ_GEM_MID-x றொ_GEMய்ட்_END றொ_MID றொ_MID-x றொன்_MID றோ_END றோ_END-x றோ_GEM_END றோ_GEM_MID றோ_GEM_MID-x றோ_GEMட்_MID றோ_GEMர்_END றோ_GEMர்_MID றோ_MID றோ_MID-x றோம்_END றோர்_END றோன்_MID ன்_END ன்_MID ன_END ன_END-x ன_MID ன_MID-x னக்_END னக்_MID னக்ஸ்_END னங்_MID னச்_END னச்_MID னஞ்_MID னட்_END னட்_MID னத்_END னத்_MID னந்_MID னப்_END னப்_MID னம்_END னம்_MID னய்_MID னர்_END னர்_MID னர்க்_MID னர்ச்_END னர்ஸ்_END னல்_END னல்_MID னள்_END னற்_GEM_MID னன்_END னன்_MID னன்ட்_END னஸ்_MID னா_END னா_END-x னா_MID னா_MID-x னாக்_END னாக்_MID னாங்க்_END னாச்_MID னாட்_MID னாத்_END னாத்_MID னாப்_END னாப்_MID னாய்_END னாய்க்_END னார்_END னார்_MID னால்_END னால்_MID னால்ட்_END னாள்_END னாற்_END னான்_END னாஸ்_MID னி_END னி_END-x னி_MID னி_MID-x னிக்_END னிக்_MID னிங்_END னிங்_MID னிச்_MID னிட்_MID னித்_MID னிந்_MID னிப்_MID னில்_END னில்_MID னின்_END னின்_MID னிஷ்_END னிஸ்_END னிஸ்_MID னிஸ்ட்_END னிஸ்ட்_MID னீ_END னீ_MID னீ_MID-x னீக்_MID னீர்_END னீர்_MID னு_END னு_END-x னு_MID னு_MID-x னுக்_MID னுஞ்_END னுண்_MID னுப்_MID னும்_END னுள்_END னுஷ்_MID னூ_MID னூ_MID-x னூட்_MID னூத்_MID னூர்_END னூர்_MID னூல்_END னூற்_GEM_MID னெ_MID னெ_MID-x னெட்_MID னெர்ஸ்_END னென்_MID னெஸ்ட்_MID னே_END னே_END-x னே_MID னே_MID-x னேச்_MID னேட்_END னேந்_MID னேற்_GEM_MID னேற்_MID னேன்_END னேன்_MID னை_END னை_END-x னை_MID னை_MID-x னைக்_END னைக்_MID னைச்_END னைச்_MID னைத்_END னைத்_MID னைந்_MID னைப்_END னைப்_MID னொ_MID னொ_MID-x னொத்_MID னோ_END னோ_END-x னோ_MID னோ_MID-x னோக்_MID னோம்_END னோர்_END ஜ்_BEG ஜ்_END ஜ்_MID ஜ_BEG ஜ_BEG-x ஜ_END ஜ_END-x ஜ_MID ஜ_MID-x ஜங்_BEG ஜங்_MID ஜட்_BEG ஜந்_BEG ஜப்_BEG ஜப்_MID ஜம்_BEG ஜம்_END ஜய்_END ஜர்_END ஜல்_END ஜன்_BEG ஜன்_END ஜஸ்_BEG ஜஸ்_MID ஜா_BEG ஜா_BEG-x ஜா_END ஜா_END-x ஜா_MID ஜா_MID-x ஜாக்_BEG ஜாங்_MID ஜாச்_END ஜாப்_MID ஜாம்_BEG ஜாம்_END ஜார்_BEG ஜார்_END ஜார்க்_BEG ஜார்ஜ்_BEG ஜான்_BEG ஜான்_END ஜி_BEG ஜி_BEG-x ஜி_END ஜி_END-x ஜி_MID ஜி_MID-x ஜிக்_MID ஜிட்_BEG ஜிட்_MID ஜித்_BEG ஜித்_END ஜித்_MID ஜிஸ்_MID ஜிஸ்ட்_MID ஜீ_BEG ஜீ_BEG-x ஜீ_MID ஜீ_MID-x ஜீத்_END ஜீத்_MID ஜீப்_BEG ஜீவ்_MID ஜு_BEG ஜு_BEG-x ஜு_END ஜு_MID ஜு_MID-x ஜுக்_MID ஜுஸ்_BEG ஜூ_BEG ஜூ_BEG-x ஜூ_MID ஜூம்_BEG ஜூன்_BEG ஜெ_BEG ஜெ_BEG-x ஜெ_MID ஜெ_MID-x ஜெக்ட்_END ஜெண்_MID ஜெர்_BEG ஜென்_BEG ஜென்_MID ஜே_BEG ஜே_BEG-x ஜே_MID ஜேந்_MID ஜேஷ்_END ஜேஸ்_MID ஜை_BEG ஜை_BEG-x ஜை_END ஜை_END-x ஜை_MID ஜை_MID-x ஜைக்_END ஜொ_BEG ஜொ_BEG-x ஜோ_BEG ஜோ_BEG-x ஜோ_MID ஜோ_MID-x ஜோக்_BEG ஜோத்_BEG ஜோன்ஸ்_BEG ஷ்_END ஷ்_MID ஷ_BEG ஷ_BEG-x ஷ_END ஷ_END-x ஷ_MID ஷ_MID-x ஷக்_END ஷக்_MID ஷங்_MID ஷத்_END ஷத்_MID ஷப்_END ஷம்_END ஷர்_BEG ஷன்_END ஷன்_MID ஷா_BEG ஷா_BEG-x ஷா_END ஷா_MID ஷா_MID-x ஷாக்_MID ஷாட்_BEG ஷாத்_END ஷாத்_MID ஷாப்_END ஷாப்_MID ஷாம்_END ஷி_BEG ஷி_BEG-x ஷி_END ஷி_END-x ஷி_MID ஷி_MID-x ஷிப்_END ஷிப்_MID ஷின்_END ஷீ_BEG ஷீ_MID ஷீர்_END ஷு_BEG ஷு_END ஷு_END-x ஷு_MID ஷுக்_MID ஷுப்_END ஷுர்_END ஷூ_BEG ஷூக்_BEG ஷூன்_BEG ஷெ_BEG ஷெ_MID ஷெ_MID-x ஷெட்_BEG ஷெண்ட்_BEG ஷெர்_BEG ஷே_BEG ஷே_MID ஷே_MID-x ஷேக்ஸ்_BEG ஷேத்_BEG ஷேந்_END ஷை_BEG ஷை_END ஷை_END-x ஷை_MID ஷைக்_END ஷைக்_MID ஷொ_END ஷோ_BEG ஷோ_BEG-x ஷோ_MID ஷ்ர_BEG ஷ்றிங்_BEG ஸ்_BEG ஸ்_END ஸ்_MID ஸ_BEG ஸ_END ஸ_END-x ஸ_MID ஸ_MID-x ஸக்_MID ஸத்_BEG ஸப்_MID ஸர்_MID ஸன்_END ஸா_BEG ஸா_BEG-x ஸா_END ஸா_END-x ஸா_MID ஸா_MID-x ஸாண்_MID ஸாண்ட்_MID ஸாம்_END ஸார்_END ஸாஸ்_END ஸி_BEG ஸி_END ஸி_END-x ஸி_MID ஸி_MID-x ஸிங்_END ஸில்_BEG ஸில்_MID ஸின்_END ஸிஸ்_BEG ஸிஸ்_END ஸிஸ்ட்_END ஸீ_BEG ஸீ_MID ஸீ_MID-x ஸீட்_MID ஸு_BEG ஸு_MID ஸு_MID-x ஸுக்_MID ஸூ_BEG ஸூ_MID ஸூக்_MID ஸெ_BEG ஸெ_END ஸெ_MID ஸெ_MID-x ஸென்ஸ்_END ஸே_BEG ஸே_BEG-x ஸே_MID ஸை_BEG ஸை_END ஸை_END-x ஸை_MID ஸை_MID-x ஸைக்_END ஸைட்_END ஸொ_BEG ஸொ_MID ஸொப்_MID ஸோ_MID ஸோ_MID-x ஸௌ_BEG ஸ்கி_uv_BEG ஸ்கி_uvன்_BEG ஸ்கீ_uv_BEG ஸ்கூ_uvல்_BEG ஸ்கெ_uvட்ச்_BEG ஸ்கே_uv_BEG ஸ்கே_uvன்_BEG ஸ்ட்_BEG ஸ்டா_uvக்_BEG ஸ்டா_uvர்ட்_BEG ஸ்டா_uvல்_BEG ஸ்டி_uv_BEG ஸ்டூ_uv_BEG ஸ்டே_uv_BEG ஸ்டே_uvட்_BEG ஸ்டை_uv_BEG ஸ்டை_uvல்_BEG ஸ்டோ_uvர்ஸ்_BEG ஸ்டோ_uvன்_BEG ஸ்தா_uv_BEG ஸ்தி_uv_BEG ஸ்பா_uv_BEG ஸ்பா_uvட்_BEG ஸ்பா_uvர்க்_BEG ஸ்பா_uvன்_BEG ஸ்பி_uv_BEG ஸ்பூ_uvன்_BEG ஸ்பெ_uv_BEG ஸ்பெ_uvன்_BEG ஸ்பே_uv_BEG ஸ்பே_uvஸ்_BEG ஸ்பை_uvக்_BEG ஸ்போ_uvர்ட்ஸ்_BEG ஸ்மட்_BEG ஸ்மி_BEG ஸ்மித்_BEG ஸ்மோக்_BEG ஸ்ரேஷ்_BEG ஸ்லா_BEG ஸ்லைஸ்_BEG ஸ்லோ_BEG ஸ்வ_BEG ஸ்வா_BEG ஸ்விட்_BEG ஸ்னே_BEG ஹ்_BEG ஹ்_END ஹ்_MID ஹ_BEG ஹ_BEG-x ஹ_END ஹ_MID ஹங்_MID ஹஞ்_MID ஹட்_MID ஹந்_BEG ஹந்_MID ஹம்_MID ஹர்_BEG ஹள்_MID ஹன்_BEG ஹன்_END ஹஸ்_BEG ஹா_BEG ஹா_BEG-x ஹா_END ஹா_END-x ஹா_MID ஹா_MID-x ஹாங்_BEG ஹாட்_MID ஹாம்_BEG ஹார்_BEG ஹார்_END ஹார்ட்_BEG ஹார்ஸ்_BEG ஹால்_END ஹாஜ்_BEG ஹி_BEG ஹி_BEG-x ஹி_END ஹி_END-x ஹி_MID ஹி_MID-x ஹிட்_BEG ஹிந்_BEG ஹிந்த்_BEG ஹிப்_BEG ஹிப்_END ஹிஸ்_BEG ஹீ_BEG ஹீ_MID ஹீட்_MID ஹு_BEG ஹு_BEG-x ஹு_MID ஹு_MID-x ஹூ_BEG ஹூக்_BEG ஹூப்_BEG ஹெ_BEG ஹெ_BEG-x ஹெ_END ஹெச்_BEG ஹெட்_BEG ஹெண்ட்_BEG ஹென்_BEG ஹே_BEG ஹே_MID ஹேட்_MID ஹேண்ட்ஸ்_BEG ஹேர்_BEG ஹை_BEG ஹை_BEG-x ஹை_MID ஹைட்_BEG ஹைட்_MID ஹைத்_BEG ஹொ_BEG ஹொ_MID ஹொ_MID-x ஹொய்_BEG ஹோ_BEG ஹோ_BEG-x ஹோ_END ஹோ_END-x ஹோ_MID ஹோட்_BEG ஹோம்ஸ்_BEG ஹௌ_MID ஹ்யூ_BEG ஹ்ரு_BEG ஹ்ஹன்_BEG க்ஷீ_BEG ஸ்ரீ_BEG";

my @shortpause=();
my @shortpause_new=();
foreach $oneChar (@ps) {
	$voiced_hash{$oneChar} = $oneChar;
}
chomp(@ps);
@ps_nasals = split( /\s+/, $nasals );
foreach $oneChar (@ps_nasals) {
	$nasal_hash{$oneChar} = $oneChar;
}
chomp(@ps_nasals);


@ps_cons = split( /\s+/, $cons );
foreach $oneChar (@ps_cons) {
	$cons_hash{$oneChar} = $oneChar;
}
chomp(@ps_cons);
my %HashPhone=();
#print $eachW;
@ps = split(/\s+/, $Phoneset);


 foreach (@ps)
  {
    $HashPhone{$_}++;
  }
  chomp(@ps);
my $check = 0;
my $oF = $voiceDir."/phr_temp";
open(fp_out, ">$oF");
@psyl = &utf2UniCode($eachW);
my $nS = $#psyl + 1;
my %Uni2IT3MAP = (); 
my %it3Type = ();
my %uniqWords = ();
# my $oFDic = "pronunciationDict";
$a = $for_morph;
#$a=$ARGV[0];
$z = 0;
$c1 = "ம்";
$x1 = length($c1);
$b1 = substr($a,-$x1,$x1);
if($c1 eq $b1)
{                  
          $z = 1;
 }
$c2 = "ள்";
$x2 = length($c2);
$b2 = substr($a,-$x2,$x2);
if($c2 eq $b2)
{                  
          $z = 2;
 }
$c3 = "ல்";
$x3 = length($c3);
$b3 = substr($a,-$x3,$x3);
if($c3 eq $b3)
{                  
          $z = 3;
 }
$c4 = "ன்";
$x4 = length($c4);
$b4 = substr($a,-$x4,$x4);
if($c4 eq $b4)
{                  
          $z = 4;
 }
$c5 = "தது";
$x5 = length($c5);
$b5 = substr($a,-$x5,$x5);
if($c5 eq $b5)
{                  
          $z = 5;
}
$c6 = "ரது";
$x6 = length($c6);
$b6 = substr($a,-$x6,$x6);
if($c6 eq $b6)
{                  
          $z = 6;
}
$c7 = "ில்லை";
$x7 = length($c7);
$b7 = substr($a,-$x7,$x7);
if($c7 eq $b7)
{                  
          $z = 7;
}
$c8 = "ய்";
$x8 = length($c8);
$b8 = substr($a,-$x8,$x8);
if($c8 eq $b8)
{                  
          $z = 8;
}
$c9 = "வே";
$x9 = length($c9);
$b9 = substr($a,-$x9,$x9);
if($c9 eq $b9)
{                  
          $z = 9;
}
$c10 = "ர்";
$x10 = length($c10);
$b10 = substr($a,-$x10,$x10);
if($c10 eq $b10)
{                  
          $z = 10;
}
$c11 = "அது";
$x11 = length($c11);
$b11 = substr($a,-$x11,$x11);
if($c11 eq $b11)
{                  
          $z = 11;
}
$c12 = "க்";
$x12 = length($c12);
$b12 = substr($a,-$x12,$x12);         
if($c12 eq $b12)
{                  
          $z = 12;
}
$c13 = "ப்";
$x13 = length($c13);
$b13 = substr($a,-$x13,$x13);
if($c13 eq $b13)
{                  
          $z = 13;
}
$c14 = "த்";
$x14 = length($c14);
$b14 = substr($a,-$x14,$x14);
if($c14 eq $b14)
{                  
          $z = 14;
}
$c15 = "யதை";
$x15 = length($c15);
$b15 = substr($a,-$x15,$x15);
if($c15 eq $b15)
{                  
          $z = 15;
}
$c16 = "மை";
$x16 = length($c16);
$b16 = substr($a,-$x16,$x16);
if($c16 eq $b16)
{                  
          $z = 16;
}
$c17 = "யே";
$x17 = length($c17);
$b17 = substr($a,-$x17,$x17);
if($c17 eq $b17)
{                  
          $z = 17;
}
$c18 = "டது";
$x18 = length($c18);
$b18 = substr($a,-$x18,$x18);
if($c18 eq $b18)
{                  
          $z = 18;
}
$c19 = "லது";
$x19 = length($c19);
$b19 = substr($a,-$x19,$x19);
if($c19 eq $b19)
{                  
          $z = 19;
 }
$c20 = "ந்து";
$x20 = length($c20);
$b20 = substr($a,-$x20,$x20);
if($c20 eq $b20)
{                  
          $z = 20;
 }
$c21 = "க்கு";
$x21 = length($c21);
$b21 = substr($a,-$x21,$x21);
if($c21 eq $b21)
{                  
          $z = 21;
}
$c22 = "னை";
$x22 = length($c22);
$b22 = substr($a,-$x22,$x22);
if($c22 eq $b22)
{                  
          $z = 22;
}
$c23 = "யை";
$x23 = length($c23);
$b23 = substr($a,-$x23,$x23);
if($c23 eq $b23)
{                  
          $z = 23;
}
open (fp_out1, ">$voiceDir/morph_tag1");
print fp_out1 "(set! a \"$z\" )" ;
close fp_out1;
#print fp_out "(set! wordstruct ' ( ";
my $sp = 0;
my $prntStr = "";

for (my $j = 0; $j < $nS; $j++) {

   #print fp_out "((";
   print fp_out "$psyl[$j]\n";
#   print "hey @shortpause_new\n";

  # print fp_out ") $sp) ";
  #print fp_out "$sp\n";
}
   #print fp_out "))\n";
close(fp_out);

sub utf2UniCode {
	my $file_path = $_[0];
	#print "Processing $utf8FileIn ...\n";
	open( FILE, "<$file_path" );
	binmode(FILE);
	my $ENDln = "\n";
	my $line  = ();
	my $t;
	my $syllabified_word;
	my @sentence;
	my $syllabified_sentence;
	my @tempsent;
	my $word  = $_[0];
	chomp($word);
	my $engl   = 0;
	my $otherl = 0;
	#foreach my $word (@words) {
	my @utf8char;
	my $initial = 0;
	my @test;
	my $tempword;
	my $hexword;
	my $decword;
	my $other = 0;
	my $eng   = 0;
	#print $word;
     	foreach ( split( //, $word ) ) {
#print( "split word $_ \n");

		push( @utf8char, &string2bin($_) );

	}
#print "utf8char @utf8char";

	my $nutf8char = $#utf8char + 1;

		#$h += $nutf8char;
	for ( my $loop = 0 ; $loop < $nutf8char ; ) {
		$t = 0;
		my $dec_input = &hex2dec( $utf8char[$loop] );
		if ( ( my $value = $dec_input & 128 ) == 0 ) {
			$t = $t | $dec_input;
			$loop++;
			$eng = 1;
		}
		elsif ( ( $value = $dec_input & 224 ) == 192 ) {
			$eng = 1;
			$t   = $t | ( $dec_input & 31 );
			$t   = $t << 6;
			$loop++;

			$t = $t | ( $dec_input & 63 );
			$loop++;
		}

		elsif ( ( $value = $dec_input & 240 ) == 224 ) {
			$other = 1;
			$t     = $t | ( $dec_input & 15 );
			$t     = $t << 6;
			$loop++;

			$dec_input = &hex2dec( $utf8char[$loop] );
			$t         = $t | ( $dec_input & 63 );
			$t         = $t << 6;
			$loop++;
			$dec_input = &hex2dec( $utf8char[$loop] );
			$t = $t | ( $dec_input & 63 );
			$loop++;
		}

		elsif ( ( $value = $dec_input & 248 ) == 240 ) {
			$other = 1;

			$t = $t + ( $dec_input & 7 );
			$t = $t << 6;
			$loop++;
			$dec_input = &hex2dec( $utf8char[$loop] );
			$t         = $t + ( $dec_input & 63 );
			$t         = $t << 6;
			$loop++;
			$dec_input = &hex2dec( $utf8char[$loop] );
			$t         = $t + ( $dec_input & 63 );
			$t         = $t << 6;
			$loop++;

			$dec_input = &hex2dec( $utf8char[$loop] );
			$t = $t + ( $dec_input & 63 );
			$loop++;
		}

		elsif ( ( $value = $dec_input & 252 ) == 248 ) {
			$other = 1;
			$t     = $t + ( $dec_input & 3 );
			$t     = $t << 6;
			$loop++;

			$dec_input = &hex2dec( $utf8char[$loop] );
			$t         = $t + ( $dec_input & 63 );
			$t         = $t << 6;
			$loop++;

			$dec_input = &hex2dec( $utf8char[$loop] );
			$t         = $t + ( $dec_input & 63 );
			$t         = $t << 6;
			$loop++;

			$dec_input = &hex2dec( $utf8char[$loop] );
			$t         = $t + ( $dec_input & 63 );
			$t         = $t << 6;
			$loop++;
			$dec_input = &hex2dec( $utf8char[$loop] );
			$t = $t + ( $dec_input & 63 );
			$loop++;

		}

		elsif ( ( $value = $dec_input & 254 ) == 252 ) {
			$other = 1;
			$t     = $t + ( $dec_input & 63 );
			$t     = $t << 6;
			$loop++;

			$dec_input = &hex2dec( $utf8char[$loop] );
			$t         = $t + ( $dec_input & 63 );
			$t         = $t << 6;
			$loop++;

			$dec_input = &hex2dec( $utf8char[$loop] );
			$t         = $t + ( $dec_input & 63 );
			$t         = $t << 6;
			$loop++;
			
			$dec_input = &hex2dec( $utf8char[$loop] );
			$t         = $t + ( $dec_input & 63 );
			$t         = $t << 6;
			$loop++;

			$dec_input = &hex2dec( $utf8char[$loop] );
			$t         = $t + ( $dec_input & 63 );
			$t         = $t << 6;
			$loop++;

			$dec_input = &hex2dec( $utf8char[$loop] );
			$t = $t + ( $dec_input & 63 );
			$loop++;
		}
		else {
			$loop++;
		}
		#print "t is $t\n";
		@tempArr=$t;
		#print @tempArr;
		my $result = &check_language($t);

		#next if ( ( $result !~ true ) );
		my $hex = &dec2hex($t);

		$decword .= " " . $t;
		#print $decword;
		$hexword .= " " . $hex;
		if ( $hex == "94D" )    #To check if halant present
		{
			$hal = 1;
		}
	}
	$hexword =~ s/^\s+|\s+$//g;
	$decword =~ s/^\s+|\s+$//g;
	my @hextemp     = split( /\s+/,            $hexword );
	my @dectemp     = split( /\s+/,            $decword );
	my @modfiedWord = &rules_for_voiced_unvoiced( \@hextemp, \@dectemp );
	my @finArr = &checkSymbol( \@dectemp, \@modfiedWord );
	#my @combTag = &combineTag(\@dectemp);
	my $nonparsed =0;
	my $engutf = "";
	#print @finArr;
	@utfdata =();
			for ( my $i = 0 ; $i < @finArr ; $i++ ) {
			if ((2943 < $finArr[$i])&&($finArr[$i] < 3072)){
			#print "@finArr\n";
			#print $unicodevalue[$j];
			if($check1 ==0 && (($finArr[$i] == 3015) &&  ($finArr[$i+1] == 3006))) {
				#print "value is $finArr[$i]";
				#$combTag[$i] = 3019;
				push( @utfdata,3019 );
				$check1 = 1;
				next;
			} elsif ($check1 == 0 && (($finArr[$i] == 3014)  &&  ($finArr[$i+1] == 3006))) {
				#print "value is $finArr[$i]";
				#$combTag[$i] = 3018;
				push( @utfdata,3018 );
				$check1 = 1;
				next;
			} 
			elsif ($check1 == 0 && (($finArr[$i] == 3014)  &&  ($finArr[$i+1] == 3031))) {
				#print "value is $finArr[$i]";
				#$combTag[$i] = 3018;
				push( @utfdata,3020 );
				$check1 = 1;
				next;
			} 
			#print "  $combTag[$i] IS next working \n";
			if($check1 == 0) {
	        		push( @utfdata,$finArr[$i] );
			} else {
				$check1 = 0;
			}
        		}
		else {
			$finArr[$i] = chr($finArr[$i]);
			$engutf = "$engutf$finArr[$i]";
			$nonparsed = $nonparsed + 1; # for spelling out english words 
			#print "!!!!!!!!!!!!!!!!!$nonparsed!!!!!!!!!!!!!!!!!!!!!!!!";
			#$nonparsed =0;
		}
	}
	#print "$engutf======================";
	if($nonparsed ne "0")
	{
		
		system("perl $voiceDir/spl_process.pl $engutf $voiceDir");
		exit;
	}
	@finArr = @utfdata ;	
	my $words = " ";
	$syllabified_sentence = &syllabify(\@finArr);
	#print "syllabified_sentence $syllabified_sentence\n";
	$syllabified_sentence =~ s/^\s+|\s+$//g;
	@syllables_unicode_array = split(/\s+/,$syllabified_sentence);
	@syllables_utf8_array =  &syllabified_utf8($syllabified_sentence);
	return &check_syllables_for_fallback(\@syllables_utf8_array, \@syllables_unicode_array );
}

sub check_syllables_for_fallback {
my $var ="";
my @outArr=();
my $k=0;
my $check =0;
my @syllable_phone_array=();

for (my $j = 0; $j <@{ $_[0] }; $j++) {

	if(${ $_[0] }[$j] eq ""){
		delete ${ $_[0] }[$j];
		delete ${ $_[1] }[$j];
	} else {
		$outArr[$k]=${ $_[0] }[$j];
		$k++;
	}
}

$nS = @outArr;
my $jj = 0;
for (my $j = 0; $j < $nS; $j++) {
	#print "out array is @outArr\n";
  my $BEG_psyl= $outArr[$j] . "$BegTag" ;
  my $MID_psyl= $outArr[$j] . "$MidTag" ;
  my $END_psyl= $outArr[$j] . "$EndTag" ;
  
   if ($j == 0 ) { 
     if (exists $HashPhone{$BEG_psyl}){
      $var = $BegTag;
    
     } elsif (exists $HashPhone{$MID_psyl}){
      $var= $MidTag;
    
     } elsif (exists $HashPhone{$END_psyl}){ 
      $var = $EndTag;
     } elsif ($outArr[$j] =~ m/_GEM/) {
	$outArr[$j] =~ s/_GEM//g;
	${ $_[1] }[$j] =~ s/$temptag//g;
	#print "i am inside $outArr[$j]\n";
	#print "i am inside ${ $_[1] }[$j]\n";
	if (exists $HashPhone{$outArr[$j].$BegTag}){
        $var = $BegTag;
        } elsif (exists $HashPhone{$outArr[$j].$MidTag}) {
	$var = $MidTag;
	} elsif (exists $HashPhone{$outArr[$j].$EndTag}) {
	$var = $EndTag;
	} else {
	$var = $BegTag;
	$check =1;
     	}
     }	else {
	$var = $BegTag;
	$check =1;
     }
    
   }
   elsif ($j == ($nS -1) ) { 
     if (exists $HashPhone{$END_psyl}){
	$var = $EndTag;
     }  elsif (exists $HashPhone{$MID_psyl}){
	$var= $MidTag;
     } elsif (exists $HashPhone{$BEG_psyl}){ 
	$var = $BegTag;
     } elsif ($outArr[$j] =~ m/_GEM/) {
	$outArr[$j] =~ s/_GEM//g;
	${ $_[1] }[$j] =~ s/$temptag//g;
#	print "i am inside ${ $_[1] }[$j]\n";
	if (exists $HashPhone{$outArr[$j].$EndTag}){
        $var = $EndTag;
        } elsif (exists $HashPhone{$outArr[$j].$MidTag}) {
	$var = $MidTag;
	} elsif (exists $HashPhone{$outArr[$j].$BegTag}) {
	$var = $BegTag;
	} else  {
	$var = $EndTag;
	$check =1;
	}
     } else  {
	$var = $EndTag;
	$check =1;
	#print "END is found \n";
     }
     
   }
   else {
     if (exists $HashPhone{$MID_psyl}){
      $var = $MidTag;
     }
     elsif (exists $HashPhone{$BEG_psyl}){
      $var= $BegTag;
     }
     elsif (exists $HashPhone{$END_psyl}){ 
      $var = $EndTag;
     } elsif ($outArr[$j] =~ m/_GEM/) {
	$outArr[$j] =~ s/_GEM//g;
	#print "i am inside ${ $_[1] }[$j]\n";
	${ $_[1] }[$j] =~ s/$temptag//g;
	if (exists $HashPhone{$outArr[$j].$MidTag}) {
        $var = $MidTag;
        } elsif (exists $HashPhone{$outArr[$j].$BegTag}) {
	$var = $BegTag;
	} elsif (exists $HashPhone{$outArr[$j].$EndTag}) {
	$var = $EndTag;
	} else {
		$var = $MidTag;
		$check =1;
		#print "MID is found \n";
   	  }
     } else {
		$var = $MidTag;
		$check =1;
		#print "MID is found \n";
     }
   }
   
   if($check == 1 ) {
	#print "does it go to fb $outArr[$j] :::::::: $j\n";
	if ($shortpause[$j] == 1){
		#$shortpause[$j] = 0;
		#@newarray1=splice(@shortpause,0,$j);
		#@newarray2=splice(@shortpause,1,@array);
		#@shortpause=();
		#push(@shortpause,@newarray1);
		#push(@shortpause,0);
		#push(@shortpause,1);
		#push(@shortpause,@newarray2);
#		print "IS this short pause\n";
		$shortpause_new[$jj++] = 0;
		#$jj++
		$shortpause_new[$jj++] = 1;
	}
	my $varia = ${ $_[1] }[$j];
	#print " i am heree $varia\n";
	@temp_array = ($varia =~ m/.../g);
	#print "--@temp_array--\n";
	$phonfied_word = &phonify(\@temp_array);
	my @phone_array = &syllabified_utf8($phonfied_word);
	foreach (@phone_array) {
	if ($shortpause[$j] != 1){
	  $shortpause_new[$jj++] = 0;
	}
	  my $phoneVal = &checkPhonesAndReplace($_, $var);
	 # print "\n ha ha $phoneVal";
	  push(@syllable_phone_array, $phoneVal);
	}
	$check = 0;
   } else {
	#print "-$outArr[$j]"."$var-\n";
	push(@syllable_phone_array,$outArr[$j].$var);
	$shortpause_new[$jj++]=$shortpause[$j];
    }
 }
#print "my @syllable_phone_array\n";
return @syllable_phone_array;
}

sub checkPhonesAndReplace {
  my $BEG_psyl= $_[0] . "$BegTag" ;
  my $MID_psyl= $_[0] . "$MidTag" ;
  my $END_psyl= $_[0] . "$EndTag" ;
  my $returnValue;
  my $phoneVar;
  my $jj;
#  print "i came $_[0]\n";
   if ($_[1] eq $BegTag ) { 
     if (exists $HashPhone{$BEG_psyl}){
      $phoneVar = $BegTag;
    
     } elsif (exists $HashPhone{$MID_psyl}){
      $phoneVar= $MidTag;
    
     } elsif (exists $HashPhone{$END_psyl}){ 
      $phoneVar = $EndTag;
     } else {
	$phoneVar = $BegTag;
     }
    $returnValue = $_[0] .$phoneVar;
	#print "return value is $returnValue\n";
   }
   elsif ($_[1] eq $EndTag ) { 
     if (exists $HashPhone{$END_psyl}){
	$phoneVar = $EndTag;
     }  elsif (exists $HashPhone{$MID_psyl}){
	$phoneVar= $MidTag;
     } elsif (exists $HashPhone{$BEG_psyl}){ 
	$phoneVar = $BegTag;
     } else  {
	$phoneVar = $EndTag;
	#print "END is found \n";
     }
     $returnValue = $_[0] .$phoneVar;
   }
   else {
     if (exists $HashPhone{$MID_psyl}){
      $phoneVar = $MidTag;
     }
     elsif (exists $HashPhone{$BEG_psyl}){
      $phoneVar= $BegTag;
     }
     elsif (exists $HashPhone{$END_psyl}){ 
      $phoneVar = $EndTag;
     } else {
		$phoneVar = $MidTag;
		#print "MID is found \n";
     }
    $returnValue = $_[0] .$phoneVar;
   }
   
return $returnValue;

}
sub checkSymbol {
	my @finalArray;
	my $k = 0;
	for ( my $i = 0 ; $i < @{ $_[0] } ; $i++ ) {
		if (
			${ $_[1] }[$i] ne "-"
			&& (   ${ $_[0] }[ $i + 1 ] > &hex2dec("BBD")
				&& ${ $_[0] }[ $i + 1 ] < &hex2dec("BD8") )
		  )
		{
			my $temp = ${ $_[1] }[$i];

			#			print "tem is $temp";
			${ $_[1] }[$i] = "-";
			${ $_[1] }[ $i + 1 ] = $temp;
			$finalArray[$k] = ${ $_[0] }[$i];
		}
		elsif ( ${ $_[1] }[$i] ne "-" ) {
			$finalArray[$k] = ${ $_[0] }[$i];
			$k++;
			$finalArray[$k] = ${ $_[1] }[$i];
		}
		else {
			$finalArray[$k] = ${ $_[0] }[$i];
		}
		$k++;
	}

	#	print @{$_[1]} ;
	return @finalArray;
}
sub syllabified_utf8 {
	my $syllbified_line = $_[0];
	my @syllabified_words;
	my $phonified_word;
	my @phonified_letters;
	my @temp_array;
	my $phones;
	my @utf8_array;
	my $syllable;
	
	$syllbified_line =~ s/\. +/\.$ENDln/g;
	@syllabified_words = split(/\s+/,$syllbified_line);
# 	print "Syllabified Word Array : @syllabified_words\n";
	foreach (@syllabified_words) {
		my @temp_syll_array = ();
		my @phonearray = ();
		@temp_syll_array = ($_ =~ m/.../g);
		#print @temp_syll_array;
		foreach $temp(@temp_syll_array) {
		if(!($temp eq $uvTagHex || $temp eq $vTagHex || $temp eq $ivTagHex || $temp eq $temptag)) {
			
			$for_morph .= chr(hex $temp);
		}
		if ($temp eq $uvTagHex)
		{
		$phones .= $uvTagStr;
		}
		elsif ($temp eq $vTagHex)
		{
		$phones .= $vTagStr;
		}
		elsif ($temp eq $ivTagHex)
		{
		$phones .= $ivTagStr;
		}
		elsif ($temp eq $temptag)
		{
		$phones .= $tempstr;
		}
		else
		{
		$phones .= chr(hex $temp);
		}
		}
		push(@utf8_array,$phones);
		$phones = "";
		$syllable = "";
	}
#	print @utf8_array;
	return @utf8_array;
}


sub string2bin($) {
	return sprintf( "%02x ", ord($_) );
}

sub hex2dec($) {
	eval "return sprintf(\"\%d\", 0x$_[0])";
}

sub check_language
{

	#my @Language_Ranges = @{$_[1]};

	#foreach my $line (@Language_Ranges)
	#{
	my $line   = "Tamil_2944-3071";
	my @values = split( /_/, $line );
	my $lan    = shift(@values);
	foreach my $ran (@values) {
		my @range = split( /-/, $ran );
		# print " $range[0]  ::::: $_[0] \n";
		if ( $range[0] <= $_[0] ) {
			if ( $_[0] <= $range[1] ) {
				return (true);
			} else {
				return false;
			}
		}
	}

	#}
}

sub dec2hex {
	my $decnum = $_[0];
	my ( $hexnum, $tempval );
	while ( $decnum != 0 ) {
		$tempval = $decnum % 16;
		$tempval = chr( $tempval + 55 ) if ( $tempval > 9 );
		$hexnum  = $tempval . $hexnum;
		$decnum  = int( $decnum / 16 );
		if ( $decnum < 16 ) {
			$decnum = chr( $decnum + 55 ) if ( $decnum > 9 );
			$hexnum = $decnum . $hexnum;
			$decnum = 0;
		}
	}
	return $hexnum;
}

sub phonify {
	my $phonified_word;
	for ( my $i = 0 ; $i < @{ $_[0] } ; $i++ ) {
		if (  &hex2dec(${ $_[0] }[$i]) > &hex2dec("B82") && &hex2dec(${ $_[0] }[$i]) < &hex2dec("B95") ) {
			$phonified_word .= ${ $_[0] }[$i] . " ";
		}
		elsif ((&hex2dec(${ $_[0] }[$i]) > &hex2dec("B94") && &hex2dec(${ $_[0] }[$i]) < &hex2dec("BBA"))) {
			if (( &hex2dec(${ $_[0] }[$i+1]) >= &hex2dec("BBE")) && (&hex2dec(${ $_[0] }[$i+1]) < &hex2dec("BCD"))) {
				$phonified_word .= ${ $_[0] }[$i];
			}
			else {
				$phonified_word .= ${ $_[0] }[$i] . " ";
			}
		}
		elsif ((&hex2dec(${ $_[0] }[$i]) >= &hex2dec("BBE")) && (&hex2dec(${ $_[0] }[$i]) <= &hex2dec("BCD"))) {
				$phonified_word =~ s/ $//g;
				$phonified_word .= ${ $_[0] }[$i] . " ";

		}
		else {
			$phonified_word =~ s/ $//g;
			$phonified_word .= ${ $_[0] }[$i] . " ";
		}
	}
#	print "phonified_word :::::::::$phonified_word";
	return $phonified_word;
}

sub syllabify {
	my $syllabified_word;
	#my @shortpause;
	#print "called @{ $_[0] } ";
	#my $k=-1;
	for ( my $i = 0 ; $i < @{ $_[0] } ; $i++ ) {
#		print "b4 passed ${ $_[0] }[$i]\n";
# Vowel check
		if (  ${ $_[0] }[$i] > &hex2dec("B83") 
			&& ${ $_[0] }[$i] < &hex2dec("B95") )
		{
			$syllabified_word .= &dec2hex(${ $_[0] }[$i] )." ";
 		#	print "Inside Vowel check loop\n";
			#$k++;
		}
		elsif( ${ $_[0] }[$i]==&hex2dec("B83")){
#			print "hi\n";
			$syllabified_word .= &dec2hex(${ $_[0] }[$i] );
		}
# Consonant check
		elsif ((${ $_[0] }[$i] > &hex2dec("B94") && ${ $_[0] }[$i] < &hex2dec("BBA")))
		{
 		#print "Inside Consonant check loop\n";
# Halant check - BCD
			if ( ${ $_[0] }[$i+1] == &hex2dec("BCD")) {
				$syllabified_word =~ s/ $//g;
				$syllabified_word .= &dec2hex(${ $_[0] }[$i]);
		#print "Inside Virama check loop\n";
 			#$k--;	
			}
			elsif ((${ $_[0] }[$i+1] >= &hex2dec("BBE")) && (${ $_[0] }[$i+1] < &hex2dec("BCE")))
			{
				$syllabified_word .= &dec2hex(${ $_[0] }[$i]);
			}
			else {
  			   #	$k++;
				$syllabified_word .= &dec2hex(${ $_[0] }[$i] ). " ";
			   }
		}
		elsif ((${ $_[0] }[$i] >= &hex2dec("BBE"))
				&& (${ $_[0] }[$i] < &hex2dec("BD7")
			))
		{       

			if ( ($i == 1 && ${ $_[0] }[$i] == &hex2dec("BCD")) ||  (${ $_[0] }[$i+1] == &hex2dec("BCD"))) {
				$syllabified_word .= &dec2hex(${ $_[0] }[$i]);
                               
                         }
			else {
				if (!((${ $_[0] }[$i-1] > &hex2dec("B94") && ${ $_[0] }[$i-1] < &hex2dec("BBA")))) {
					$syllabified_word =~ s/ $//g;
					$syllabified_word .= &dec2hex(${ $_[0] }[$i]);
					#$k--;
			   	} else {
					#$k++;
					$syllabified_word .= &dec2hex(${ $_[0] }[$i] ). " ";
				#	print "comes \n";
					#if((${ $_[0] }[$i] == &hex2dec("BCD"))&& (${ $_[0] }[$i-1] == ${ $_[0] }[$i+1])) {
						#$shortpause[$k]=1;
#						print "Short paused $k\n";
			   		#}
			 	}

			}

#				$syllabified_word .= ${ $_[0] }[$i]." ";
		}
		elsif (${ $_[0] }[$i] > &hex2dec("B81") || ${ $_[0] }[$i] < &hex2dec("B84"))

		{
			$syllabified_word =~ s/ $//g;
			$syllabified_word .= &dec2hex(${ $_[0] }[$i] ). " ";
		}
		

	}

	#$syllabified_word = join(' ',split(' ',$syllabified_word));
	#print "Syyll is $syllabified_word :::::::::: $forHalant \n";
#print $syllabified_word;
	return $syllabified_word;
}

sub combineTag
{
my @combTag;
my $l=0;
my $k=@{ $_[0] };
# Combine the initial EMPTY char as well
$combTag[$l] = ${ $_[0] }[0];
for(my $j=1;$j<=$k;)
{
if(${ $_[0] }[$j]!=95)
{
$combTag[$l]=${ $_[0] }[$j];
$l++;
$j++;
}
# Check for '_' (95) and 'u' (117)
elsif((${ $_[0] }[$j]==95) && (${ $_[0] }[$j+1]==117))
{
$combTag[$l]=&hex2dec($uvTagHex);
$l++;
$j=$j+3;
}
# Check for '_' (95) and 'i' (105)
elsif((${ $_[0] }[$j]==95) && (${ $_[0] }[$j+1]==105))
{
$combTag[$l]=&hex2dec($ivTagHex);
$l++;
$j=$j+3;
}
# Check for '_' (95) and 'v' (118)
elsif((${ $_[0] }[$j]==95) && (${ $_[0] }[$j+1]==118))
{
$combTag[$l]=&hex2dec($vTagHex);
$l++;
$j=$j+2;
}
else
{
print "Wrong character used for tagging \n";
}
}
# print "CombinedTag:@combTag\n";
return @combTag;
}
sub rules_for_voiced_unvoiced {
	my @tag_voice_unvoiced;
	for ( my $i = 0 ; $i < @{ $_[0] } ; $i++ ) {

		#print  ${ $_[0] }[ $i ]  ."\n";
		if ( exists $voiced_hash{ ${ $_[0] }[$i] } ) {

			#print "Rules need to be applied $i \n";
			if ( (( ${ $_[1] }[$i] == ${ $_[1] }[ $i + 2 ]) && (${ $_[1] }[ $i + 1 ] == &hex2dec("BCD"))) || (${ $_[1] }[ $i + 1 ] == &hex2dec("BCD") ) ) { #Gemination
				$tag_voice_unvoiced[$i] = "-";
				#print " ${ $_[1] }[ $i ] fire-fire \n";
			}
			elsif (( $i > 0 ) && (( exists $nasal_hash{ ${ $_[0] }[ $i - 1 ] } ) || ( exists $nasal_hash{ ${ $_[0] }[ $i - 2 ] })))
			{ #Nasal check for Sa, after na, and ma
				if (((${ $_[1] }[$i] == &hex2dec("B9A")) && (${ $_[1] }[ $i - 1 ] != &hex2dec("BCD"))) || ((${ $_[1] }[$i] == &hex2dec("B9A")) && ((${ $_[1] }[ $i - 2 ] == &hex2dec("BA9")) || (${ $_[1] }[ $i - 2 ] == &hex2dec("BAE")))))
				{
				$tag_voice_unvoiced[$i] = $unVoiced_tag;
				#print $tag_voice_unvoiced[$i];
				}
				else
				{#Nasal check
				$tag_voice_unvoiced[$i] = $voiced_tag;
				#print $tag_voice_unvoiced[$i];
				}
			}
			elsif (( $i > 0 ) && (   ${ $_[1] }[ $i - 1 ] != &hex2dec("BCD") && ${ $_[1] }[ $i + 1 ] != &hex2dec("BCD")))
			{ #Vowel check
				if ((${ $_[1] }[$i] == &hex2dec("B9A")) ||((${ $_[1] }[$i] == &hex2dec("BAA") ) && ( ${ $_[1] }[ $i - 1 ] == &hex2dec("B83"))))
				{ #Check for sa Between Vowels
				$tag_voice_unvoiced[$i] = $unVoiced_tag;
				#print "--$tag_voice_unvoiced[$i]\n";
				}
				else
				{
				$tag_voice_unvoiced[$i] = $voiced_tag;
				}


			}
			elsif (( $i > 0 ) && ((exists $voiced_hash {${ $_[0] }[$i]}) && (${ $_[1] }[ $i - 1 ] == &hex2dec("BCD") && ($cons_hash{${ $_[0] }[ $i - 2 ]}))))
			{
					if (${ $_[1] }[$i] == &hex2dec("B9A"))
					{ #Check for sa After cons
					$tag_voice_unvoiced[$i] = $unVoiced_tag;
					#print $tag_voice_unvoiced[$i];
					}
					else {
					$tag_voice_unvoiced[$i] = $voiced_tag;
					}
			}
			else {
				if ((( $i > 0 ) && (${ $_[1] }[$i] == &hex2dec("B9A"))) || (( $i > 0 ) && (${ $_[1] }[$i] == &hex2dec("B9A")) && (${ $_[1] }[ $i - 2 ] == &hex2dec("BB1") || ${ $_[1] }[ $i - 2 ] == &hex2dec("B9F"))))
				{ #Check for sa Germination
				$tag_voice_unvoiced[$i] = $interVoiced_tag;
				#print "-$tag_voice_unvoiced[$i]-";
				}
				else
				{
				$tag_voice_unvoiced[$i] = $unVoiced_tag;
				}
			}

		}
# START : For GEM Tag addition
		elsif  (( ${ $_[1] }[$i] == &hex2dec("BB1") ) && (${ $_[1] }[ $i + 2 ] == &hex2dec("BB1")) && (${ $_[1] }[ $i + 1 ] == &hex2dec("BCD")))
			{ # Rules added for Gemination Tagging
				#print "@{ $_[0] }\n";
				$tag_voice_unvoiced[$i] = $temp_Tag;
				#print " ${ $_[1] }[ $i ] fire-fire \n";
			}
		elsif (($i>0) && (${ $_[1] }[$i] == &hex2dec("BB1")) && (${ $_[1] }[$i-2] == &hex2dec("BB1"))){
				$tag_voice_unvoiced[$i] = $temp_Tag;
				}# Ending
# END : For GEM Tag addition
		else {
			$tag_voice_unvoiced[$i] = "-";
		}
		
	}
	#print "KAKAKAKA @tag_voice_unvoiced\n" ;
	return @tag_voice_unvoiced;
}
