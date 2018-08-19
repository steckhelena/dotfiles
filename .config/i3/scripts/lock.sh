#!/usr/bin/env bash

#icon="$HOME/.xlock/icon.png"
tmpimg="/tmp/screen.png"
tmpln="$HOME/.cache/i3lock/l_blur.png"

#(( $# )) && { icon=$1; }

scrot -z $tmpimg
rm $tmpln
ln -s $tmpimg $tmpln
convert $tmpln  -filter Gaussian -resize 20% -fill black -colorize 60% \
      -define filter:sigma=0.5 -resize 500% $tmpln
betterlockscreen -l blur
#convert "$tmpln" "$icon" -gravity center -composite -matte "$tmpbg"
#i3lock -i "$tmpln"
