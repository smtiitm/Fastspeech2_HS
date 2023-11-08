#!/bin/bash

inp_file=$1
out_file=$2
rand_num=$3
ssn_parser_folder=$4

cp -r ${ssn_parser_folder} ${ssn_parser_folder}_${rand_num}

bash ${ssn_parser_folder}_${rand_num}/non_parallel-parser.sh ${inp_file} ${out_file} ${ssn_parser_folder}_${rand_num} ${rand_num}

rm -rf ${ssn_parser_folder}_${rand_num}