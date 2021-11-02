#!/usr/bin/env bash

tmpimg="/tmp/screen.png"
tmpln="$HOME/.cache/betterlockscreen/current/lock_blur.png"

scrot -o -z $tmpimg
rm $tmpln
ln -s $tmpimg $tmpln
convert $tmpln  -filter Gaussian -resize 20% -fill black -colorize 50% \
      -define filter:sigma=0.6 -resize 500% $tmpln
betterlockscreen -l blur
