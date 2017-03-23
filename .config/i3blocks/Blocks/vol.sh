#!/bin/bash

statusLine=$(amixer get Master | tail -n 1)
Vol=$(echo "${statusLine}" | awk -F ' ' '{print $5}' | tr -d '[]%')
Mute=$(amixer -c 0 get Master | grep "Mono:" | awk '{print $6}' | tr -d "[-]")

if [ "$Mute" = "off" ];then
    echo -e " Mute"
else
    echo -e " $Vol %"
fi

unset Vol
unset Mute
