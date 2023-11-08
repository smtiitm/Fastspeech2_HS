#!/bin/bash
lexicon_phone=$1

sed -i 's/aa/A/g' $lexicon_phone
sed -i 's/ii/I/g' $lexicon_phone
sed -i 's/uu/U/g' $lexicon_phone
sed -i 's/ee/E/g' $lexicon_phone
sed -i 's/oo/O/g' $lexicon_phone
sed -i 's/nn/N/g' $lexicon_phone

sed -i 's/ae/ऍ/g' $lexicon_phone
sed -i 's/ag/ऽ/g' $lexicon_phone

sed -i 's/au/औ/g' $lexicon_phone
sed -i 's/axx/अ/g' $lexicon_phone
sed -i 's/ax/ऑ/g' $lexicon_phone
sed -i 's/bh/B/g' $lexicon_phone
sed -i 's/ch/C/g' $lexicon_phone
sed -i 's/dh/ध/g' $lexicon_phone


sed -i 's/dx/ड/g' $lexicon_phone
sed -i 's/dxh/ढ/g' $lexicon_phone
sed -i 's/dxhq/T/g' $lexicon_phone
sed -i 's/dxq/D/g' $lexicon_phone
sed -i 's/ei/ऐ/g' $lexicon_phone
sed -i 's/ai/ऐ/g' $lexicon_phone
sed -i 's/eu/உ/g' $lexicon_phone

sed -i 's/gh/घ/g' $lexicon_phone
sed -i 's/gq/G/g' $lexicon_phone
sed -i 's/hq/H/g' $lexicon_phone
sed -i 's/jh/J/g' $lexicon_phone
sed -i 's/kh/ख/g' $lexicon_phone
sed -i 's/khq/K/g' $lexicon_phone
sed -i 's/kq/क/g' $lexicon_phone
sed -i 's/ln/ൾ/g' $lexicon_phone
sed -i 's/lw/ൽ/g' $lexicon_phone
sed -i 's/lx/ള/g' $lexicon_phone
sed -i 's/mq/M/g' $lexicon_phone
sed -i 's/nd/न/g' $lexicon_phone
sed -i 's/ng/ङ/g' $lexicon_phone
sed -i 's/nj/ञ/g' $lexicon_phone
sed -i 's/nk/Y/g' $lexicon_phone

sed -i 's/nw/ൺ/g' $lexicon_phone
sed -i 's/nx/ण/g' $lexicon_phone
sed -i 's/ou/औ/g' $lexicon_phone
sed -i 's/ph/P/g' $lexicon_phone
sed -i 's/rq/R/g' $lexicon_phone
sed -i 's/rqw/ॠ/g' $lexicon_phone
sed -i 's/rw/ർ/g' $lexicon_phone
sed -i 's/rx/र/g' $lexicon_phone
sed -i 's/sh/श/g' $lexicon_phone

sed -i 's/sx/ष/g' $lexicon_phone
sed -i 's/th/थ/g' $lexicon_phone
sed -i 's/tx/ट/g' $lexicon_phone
sed -i 's/txh/ठ/g' $lexicon_phone
sed -i 's/wv/W/g' $lexicon_phone
sed -i 's/zh/Z/g' $lexicon_phone
