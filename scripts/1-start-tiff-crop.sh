#! /usr/bin/env bash
cd /Image
find . -name "*.tif" -print0 | while read -d $'\0' tiffile
do
mkdir /Images/out
echo "$tiffile"
tifpath=${tiffile:2}
echo $tifpath
tifout=./out/$tifpath
echo $tifout
filepath="$(dirname "${tifout}")"
echo $filepath
if [ ! -d $filepath ]
then
  mkdir -p $filepath
fi

if [ -f "$tifout" ]; then
echo "$tifout exists."
else 
echo "$tifout does not exists."
bash /scripts/tiffcrop.sh 1 yes $tiffile $tifout
fi
done