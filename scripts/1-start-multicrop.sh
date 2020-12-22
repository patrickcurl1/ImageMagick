#! /usr/bin/env bash
cd /Images
find . -name "*.tif" -not -path ./out -print0 | while read -d $'\0' tiffile
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
bash /scripts/multicrop $tiffile $tifout
fi
done