#!/bin/bash

ifile=$1
ofile=$2

cp $ifile $ofile

sed -i 's/"aa"/"A"/g' $ofile
sed -i 's/"ii"/"I"/g' $ofile
sed -i 's/"uu"/"U"/g' $ofile
sed -i 's/"ee"/"E"/g' $ofile
sed -i 's/"oo"/"O"/g' $ofile
sed -i 's/"nn"/"N"/g' $ofile

sed -i 's/"ae"/"ऍ"/g' $ofile
sed -i 's/"ag"/"ऽ"/g' $ofile

sed -i 's/"au"/"औ"/g' $ofile
sed -i 's/"axx"/"अ"/g' $ofile
sed -i 's/"ax"/"ऑ"/g' $ofile
sed -i 's/"bh"/"B"/g' $ofile
sed -i 's/"ch"/"C"/g' $ofile
sed -i 's/"dh"/"ध"/g' $ofile


sed -i 's/"dx"/"ड"/g' $ofile
sed -i 's/"dxh"/"ढ"/g' $ofile
sed -i 's/"dxhq"/"T"/g' $ofile
sed -i 's/"dxq"/"D"/g' $ofile
sed -i 's/"ei"/"ऐ"/g' $ofile
sed -i 's/"ai"/"ऐ"/g' $ofile
sed -i 's/"eu"/"உ"/g' $ofile

sed -i 's/"gh"/"घ"/g' $ofile
sed -i 's/"gq"/"G"/g' $ofile
sed -i 's/"hq"/"H"/g' $ofile
sed -i 's/"jh"/"J"/g' $ofile
sed -i 's/"kh"/"ख"/g' $ofile
sed -i 's/"khq"/"K"/g' $ofile
sed -i 's/"kq"/"क"/g' $ofile
sed -i 's/"ln"/"ൾ"/g' $ofile
sed -i 's/"lw"/"ൽ"/g' $ofile
sed -i 's/"lx"/"ള"/g' $ofile
sed -i 's/"mq"/"M"/g' $ofile
sed -i 's/"nd"/"न"/g' $ofile
sed -i 's/"ng"/"ङ"/g' $ofile
sed -i 's/"nj"/"ञ"/g' $ofile
sed -i 's/"nk"/"Y"/g' $ofile

sed -i 's/"nw"/"ൺ"/g' $ofile
sed -i 's/"nx"/"ण"/g' $ofile
sed -i 's/"ou"/"औ"/g' $ofile
sed -i 's/"ph"/"P"/g' $ofile
sed -i 's/"rq"/"R"/g' $ofile
sed -i 's/"rqw"/"ॠ"/g' $ofile
sed -i 's/"rw"/"ർ"/g' $ofile
sed -i 's/"rx"/"र"/g' $ofile
sed -i 's/"sh"/"श"/g' $ofile

sed -i 's/"sx"/"ष"/g' $ofile
sed -i 's/"th"/"थ"/g' $ofile
sed -i 's/"tx"/"ट"/g' $ofile
sed -i 's/"txh"/"ठ"/g' $ofile
sed -i 's/"wv"/"W"/g' $ofile
sed -i 's/"zh"/"Z"/g' $ofile
