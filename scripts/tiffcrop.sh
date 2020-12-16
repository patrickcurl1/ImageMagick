#!/bin/bash

#_______________________________________________________________________________

# Script to deskew and crop black borders in TIFF files

# Syntax

# bash path/to/tiffcrop.sh thresh deskew path/to/infile path/to/outfile

# Example
# bash tiffcrop.sh 1 yes Scan_0040.tif Scan_0040_cropped.tif

# thresh is the threshold in percent to find the x or y coordinate from the
# sides where the graylevel first reaches the threshold value above 0 (black)
# Nominal value is 1

# deskew is a flag to specify whether to deskew or not. 
# Values are: yes or no

#_______________________________________________________________________________

# get input arguments
thresh="$1"
deskew="$2"
infile="$3"
outfile="$4"


# read input and deskew
if [ "$deskew" = "yes" ]; then
	magick -quiet "$infile" +repage -background black -deskew 40% tmpI.mpc
else
	magick -quiet "$infile" +repage tmpI.mpc
fi

# find left crop amount
left=`magick tmpI.mpc -negate -scale x1! txt: | tail -n +2 | tr -cs "0-9.\n" " " | \
awk -v thresh=$thresh '{x=$1; val=$5; if (val>=thresh) {print x; exit}}'`
#echo $left

# find right crop amount
right=`magick tmpI.mpc -negate -scale x1! -flop txt: | tail -n +2 | tr -cs "0-9.\n" " " | \
awk -v thresh=$thresh '{x=$1; val=$5; if (val>=thresh) {print x; exit}}'`
#echo $right

# find top crop amount
top=`magick tmpI.mpc -negate -scale 1x! txt: | tail -n +2 | tr -cs "0-9.\n" " " | \
awk -v thresh=$thresh '{y=$2; val=$5; if (val>=thresh) {print y; exit}}'`
#echo $top

# find bottom crop amount
bottom=`magick tmpI.mpc -negate -scale 1x! -flip txt: | tail -n +2 | tr -cs "0-9.\n" " " | \
awk -v thresh=$thresh '{y=$2; val=$5; if (val>=thresh) {print y; exit}}'`
#echo $bottom

# get input dimensions
WxH=`magick -quiet -ping "$infile" -format "%wx%h" info:`
W=`echo $WxH | cut -dx -f1`
H=`echo $WxH | cut -dx -f2`

# compute crop values
ww=$((W-left-right))
hh=$((H-top-bottom))
xo=$left
yo=$top

cropvals="${ww}x${hh}+${xo}+${yo}"
#echo $cropvals

# crop image
magick -quiet tmpI.mpc -crop $cropvals +repage -compress group4 "$outfile"

# remove temps
rm -f tmpI.mpc tmpI.cache

exit 0

