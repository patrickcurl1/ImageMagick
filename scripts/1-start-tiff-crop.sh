#! /usr/bin/env bash
cd /Images
counter=1
until [ $counter -lt 0 ]
do
find . -name "*.tif" -not -path "./out/*" -print0 | while read -d $'\0' tiffile
do
mkdir /Images/out
echo "image to be processed = $tiffile"
tifpath=${tiffile:2}
echo "image path = $tifpath"
tifout=./out/$tifpath
echo "image out path = $tifout"
filepath="$(dirname "${tifout}")"
echo "image file path = $filepath"
if [ ! -d $filepath ]
then
  mkdir -p $filepath
fi

if [ -f "$tifout" ]; then
echo "$tifout exists, moving on to the next image."
else 
echo "$tifout does not exists creating image."
bash /scripts/tiffcrop.sh 1 yes $tiffile $tifout
fi
done
((counter++))
done
