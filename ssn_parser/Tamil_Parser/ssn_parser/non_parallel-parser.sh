#!/bin/bash

unique_words=$1
output_file_name=$2
parser_path=$3
rand_num=$4
phone_file_name='phone_out_file'
cp ${unique_words} ${parser_path}/
curr_path=$PWD
cd ${parser_path}
rm ${phone_file_name}.words ${phone_file_name}.cls ${phone_file_name}.err ${phone_file_name}
rm -rf temp_output_string phn tempword lists/tmp lists/nasal lists/trans_word lists/out_word

while IFS= read -r word; do
        echo $word
        echo $word > tempword
        # echo $word
        perl scripts/vuv.pl tempword 2> temp_output_string
        output=`cat lists/out_word`
        out_str=`cat temp_output_string`
        # echo "<beg>".$output."<end>"
        # echo "<beg>".$out_str."<end>"
        if [[ $out_str != "" ]];
        then
        # echo $word
        echo $word >> ${phone_file_name}.err
        else
        echo $word >> ${phone_file_name}.words
        echo $output >> ${phone_file_name}.cls
        fi
        rm -rf phn tempword lists/tmp lists/nasal lists/trans_word lists/out_word
done < <(grep "" ${unique_words})

rm -rf temp_output_string phn tempword lists/tmp lists/nasal lists/trans_word lists/out_word

cp ${phone_file_name}.cls ${phone_file_name}
sed -i 's/ /""/g' ${phone_file_name}
sed -i 's/^/""/g' ${phone_file_name}
sed -i 's/$/""/g' ${phone_file_name}
bash get_phone_mapped_text.sh ${phone_file_name}
sed -i 's/"//g' ${phone_file_name}
sed -i 's/ //g' ${phone_file_name}

echo $PWD

words_str=`cat ${phone_file_name}.words`
if [[ words_str != "" ]];
then
paste -d'\t' ${phone_file_name}.words ${phone_file_name} > ${output_file_name}
echo ${output_file_name}
else
touch ${output_file_name}
fi

err_str=`cat ${phone_file_name}.err`
if [[ $err_str != "" ]];
then
echo $err_str
bash phonify_wrapper.sh ${parser_path}/${phone_file_name}.err ${output_file_name}.err.out ${rand_num} /var/www/html/IITM_TTS/E2E_TTS_FS2/text_proc/text2phone/
cat ${output_file_name}.err.out >> ${output_file_name}
echo ${output_file_name}
fi

cd ${curr_path}
