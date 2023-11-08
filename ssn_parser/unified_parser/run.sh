#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "Usage: ./run.sh <input-file-with-unique-words> <output-CLS-file>" >&2
	exit 1
fi

input_uniq_list=$1
output_uniq_list=$2

rm -rf tempFolder
mkdir tempFolder

awk '{print $s "\t" "tempFolder/Output_"NR".txt"}' $input_uniq_list > tempFile.txt
less tempFile.txt | parallel --colsep '\t' "valgrind ./unified-parser {1} {2} 1 0 0 0 >&1"
less tempFile.txt | parallel -k --colsep '\t' "cat {2}" > tempOutput.txt
bash get_phone_mapped_text.sh tempOutput.txt tempCLS.txt
sed "s/[[:punct:][:space:][:blank:][0]]*//g" tempCLS.txt | sed 's/ *setwordstruct *//g' | sed -e 's/\(.\)/\1 /g' > $output_uniq_list

rm -rf tempFolder tempFile.txt tempOutput.txt tempCLS.txt

