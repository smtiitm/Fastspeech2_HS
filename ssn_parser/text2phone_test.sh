#!/bin/bash

inpFile=$1
outFile=$2
langId=$3
randNum=$4

basePath=$5
currPath=$PWD
mapFileFolder='/var/www/html/IITM_TTS/E2E_TTS_FS2/text_proc/text2phone/mapFiles'
# echo $currPath
# basePath=/var/www/html/IITM_TTS/E2E_TTS_FS2/text_proc/text2phone

dictFile=${basePath}/phone_dict/${langId}_phone-char_mapping-dict_full.txt
unifParFold=${basePath}/unified_parser

tempDictFile=.text_temp_dict_${randNum}.txt
tempListFile=.text_temp_list_${randNum}.txt
outFileMap=${mapFileFolder}/map_${randNum}.txt
uniqFile=.uniq_${randNum}.txt
uniParList=.uniPar_${randNum}.txt
uniParTemp=.uniTemp_${randNum}.txt
uniParOut=.uniOut_${randNum}.txt

# tempDictFile=text_temp_dict_${randNum}.txt
# tempListFile=text_temp_list_${randNum}.txt
# outFileMap=map_${randNum}.txt
# uniqFile=uniq_${randNum}.txt
# uniParList=uniPar_${randNum}.txt
# uniParTemp=uniTemp_${randNum}.txt
# uniParOut=uniOut_${randNum}.txt


cut -d' ' -f2- $inpFile | tr ' ' '\n' | sort | uniq | sed 's/$/ /g' | sed 's/^/\^/g' > $uniqFile
sed -i '/^$/d' $uniqFile
sed -i '/^ $/d' $uniqFile
sed -i '/^  $/d' $uniqFile
# wc -l $uniqFile
grep -f $uniqFile $dictFile | sed 's/ \+/ /g' | sort | uniq > $tempDictFile
cut -d' ' -f1 $tempDictFile | sort | uniq -d | sed 's/$/ /g' | sed 's/^/\^/g' > $tempListFile
grep -v -f $tempListFile $tempDictFile > $outFileMap
# wc -l $outFileMap
less $tempListFile | parallel -k "grep {1} $tempDictFile | tail -1" >> $outFileMap
# wc -l $outFileMap

sed -i 's/^\^/(/g' $uniqFile
sed -i 's/ $/)/g' $uniqFile
grep -v -f <(cut -d' ' -f1 $outFileMap | sed 's/$/)/g' | sed 's/^/(/g') $uniqFile > $unifParFold/$uniParList
# wc -l $unifParFold/$uniParList
sed -i 's/[)(]//g' $uniqFile
sed -i 's/[)(]//g' $unifParFold/$uniParList
sed -i '/^$/d' $unifParFold/$uniParList
sed -i '/^ $/d' $unifParFold/$uniParList
sed -i '/^  $/d' $unifParFold/$uniParList

rm $tempDictFile
rm $tempListFile
rm $uniqFile

cd $unifParFold
mkdir uniPar_${randNum}
nj=$(wc -l $uniParList | cut -d' ' -f1) # number of parallel jobs
if [ $nj -gt 48 ]
then
        nj=48
fi

awk -v var=${randNum} '{printf "%s\tuniPar_%s/word_%04d.txt\n",$0,var,NR}' $uniParList | parallel -j$nj --colsep '\t' "valgrind ./unified-parser {1} {2} 1 0 0 0 > /dev/null 2> /dev/null"

cat uniPar_${randNum}/*.txt > $uniParTemp
rm -rf uniPar_${randNum}
bash get_phone_mapped_text_updated.sh $uniParTemp $uniParOut
sed -i "s:^(set! wordstruct '::g" $uniParOut
sed -i 's:[)("0 ]::g' $uniParOut
# wc -l $uniParList
# wc -l $uniParOut
paste -d' ' $uniParList $uniParOut >> $outFileMap

rm $uniParList
rm $uniParTemp
rm $uniParOut
cd $currPath
# wc -l $outFileMap

cp $inpFile $outFile
python3 ${basePath}/phoneReplace.py $outFileMap $outFile $basePath $randNum
# sed -i 's/$/ /g' $outFile
# awk '{ print length($1) " " $0; }' $outFileMap | sort -nr | parallel -j1 -k --colsep ' ' "sed -i 's:{2}:{3}:g' ${outFile}"
# sed -i 's/ \+/ /g' ${outFile}
# sed -i 's/ \+$//g' ${outFile}

# rm $outFileMap
