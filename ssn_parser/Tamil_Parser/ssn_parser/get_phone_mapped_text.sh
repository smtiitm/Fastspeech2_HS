#!/bin/bash
in_file=$1

sed -i 's/"aa"/"A"/g' $in_file
sed -i 's/"ii"/"I"/g' $in_file
sed -i 's/"uu"/"U"/g' $in_file
sed -i 's/"ee"/"E"/g' $in_file
sed -i 's/"oo"/"O"/g' $in_file
sed -i 's/"nn"/"N"/g' $in_file

sed -i 's/"ae"/"ऍ"/g' $in_file
sed -i 's/"ag"/"ऽ"/g' $in_file

sed -i 's/"au"/"औ"/g' $in_file
sed -i 's/"ax"/"ऑ"/g' $in_file
sed -i 's/"bh"/"B"/g' $in_file
sed -i 's/"ch"/"C"/g' $in_file
sed -i 's/"dh"/"ध"/g' $in_file


sed -i 's/"dx"/"ड"/g' $in_file
sed -i 's/"dxh"/"ढ"/g' $in_file
sed -i 's/"dxhq"/"ढ़"/g' $in_file
sed -i 's/"dxq"/"ड़"/g' $in_file
sed -i 's/"ei"/"ऐ"/g' $in_file
sed -i 's/"ai"/"ऐ"/g' $in_file
sed -i 's/"eu"/"उ"/g' $in_file

sed -i 's/"gh"/"घ"/g' $in_file
sed -i 's/"gq"/"ग़"/g' $in_file
sed -i 's/"hq"/"H"/g' $in_file
sed -i 's/"jh"/"J"/g' $in_file
sed -i 's/"kh"/"ख"/g' $in_file
sed -i 's/"khq"/"ख़"/g' $in_file
sed -i 's/"kq"/"क़"/g' $in_file
sed -i 's/"ln"/"ൾ"/g' $in_file
sed -i 's/"lw"/"ൽ"/g' $in_file
sed -i 's/"lx"/"ള"/g' $in_file
sed -i 's/"mq"/"M"/g' $in_file
sed -i 's/"nd"/"ऩ"/g' $in_file
sed -i 's/"ng"/"ङ"/g' $in_file
sed -i 's/"nj"/"ञ"/g' $in_file
sed -i 's/"nk"/"़"/g' $in_file

sed -i 's/"nw"/"ൺ"/g' $in_file
sed -i 's/"nx"/"ण"/g' $in_file
sed -i 's/"ou"/"औ"/g' $in_file
sed -i 's/"ph"/"P"/g' $in_file
sed -i 's/"rq"/"R"/g' $in_file
sed -i 's/"rqw"/"ॠ"/g' $in_file
sed -i 's/"rw"/"ർ"/g' $in_file
sed -i 's/"rx"/"ऱ"/g' $in_file
sed -i 's/"sh"/"श"/g' $in_file

sed -i 's/"sx"/"ष"/g' $in_file
sed -i 's/"th"/"थ"/g' $in_file
sed -i 's/"tx"/"ट"/g' $in_file
sed -i 's/"txh"/"ठ"/g' $in_file
sed -i 's/"wv"/"W"/g' $in_file
sed -i 's/"zh"/"Z"/g' $in_file

