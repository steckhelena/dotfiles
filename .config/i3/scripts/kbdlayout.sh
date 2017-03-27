#!/bin/bash

res=$(echo "US-International;US-Default" | rofi -sep ";" -dmenu -p "Keyboard Layout:" -hide-scrollbar -width 200 -lines 2 -i)

if [ $res = "US-International" ]; then
    setxkbmap -layout "us" -variant "intl"
fi
if [ $res = "US-Default" ]; then
    setxkbmap -layout "us"
fi
exit 0
