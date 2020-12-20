cd /Image
find . -name "*.tif" -print0 | while read -d $'\0' tiffile
do
mkdir out
echo "$tiffile"
tifpath=${tiffile:2}
echo $tifpath
tifout=./out/$tifpath
echo $tifout
if [ -f "$tifout" ]; then
echo "$tifout exists."
else 
echo "$tifout does not exists."
bash /scripts/tiffcrop.sh 1 yes $tiffile $tifout
fi
done