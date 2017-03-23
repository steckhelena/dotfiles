#!/bin/bash

res=$(echo "Logout;Suspend;Restart;Shutdown;Cancel" | rofi -sep ";" -dmenu -p "Power:" -hide-scrollbar -width 200 -lines 5 -i)

if [ $res = "Logout" ]; then
    i3-msg exit
fi
if [ $res = "Suspend" ]; then
    systemctl suspend
fi
if [ $res = "Restart" ]; then
    systemctl reboot
fi
if [ $res = "Shutdown" ]; then
    systemctl poweroff
fi
exit 0
