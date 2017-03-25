#!/usr/bin/env bash

bgfolder="$HOME/.wallpaper"
bgtimer=300

# Changes to a random wallpaper in bgfolder after the seconds defined by bgtimer
while true
do
feh --randomize --bg-fill $bgfolder/*
sleep $bgtimer
done
