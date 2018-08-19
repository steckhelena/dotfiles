#!/usr/bin/env bash

#icon="$HOME/.xlock/icon.png"
tmpimg="/tmp/screen.png"
tmpbg="$HOME/.cache/i3lock/l_blur.png"

#(( $# )) && { icon=$1; }

scrot -z $tmpbg
convert $tmpbg  -filter Gaussian -resize 20% \
      -define filter:sigma=0.5 -resize 500% $tmpbg
betterlockscreen -l blur
#convert "$tmpbg" "$icon" -gravity center -composite -matte "$tmpbg"
#i3lock -i "$tmpbg"
