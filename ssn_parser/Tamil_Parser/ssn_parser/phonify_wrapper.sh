#!/bin/bash

inpFile=$1
outFile=$2
randNum=$3
basePath=$4
currPath=$PWD
unifParFold=${basePath}/unified_parser
uniParOut=.uniOut_${randNum}.txt
uniParList=$inpFile
uniParTemp=.uniTemp_${randNum}.txt

cd $unifParFold
mkdir uniPar_${randNum}
nj=$(wc -l $inpFile | cut -d' ' -f1) # number of parallel jobs
if [ $nj -gt 48 ]
then
        nj=48
fi
awk -v var=${randNum} '{printf "%s\tuniPar_%s/word_%04d.txt\n",$0,var,NR}' $uniParList | parallel -j $nj --colsep '\t' "valgrind ./unified-parser {1} {2} 1 0 0 0 > /dev/null 2> /dev/null" > /dev/null 2> /dev/null

cat uniPar_${randNum}/*.txt > $uniParTemp
rm -rf uniPar_${randNum}
bash get_phone_mapped_text_updated.sh $uniParTemp $uniParOut
sed -i "s:^(set! wordstruct '::g" $uniParOut
sed -i 's:[)("0 ]::g' $uniParOut
paste -d' ' $uniParList $uniParOut >> $outFile


rm $uniParTemp
rm $uniParOut
cd $currPath

#TODO phone replace
# python3 ${basePath}/phoneReplace.py $outFileMap $outFile $basePath $randNum