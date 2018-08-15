#!/bin/bash

res=$(echo "	Logout;	Suspend;	Restart;	Shutdown;	Cancel" | rofi -sep ";" -dmenu -hide-scrollbar -i -theme PowerOffMenu)

if [[ $res = *"Logout"* ]]; then
    ~/.config/i3/scripts/graceful_shutdown.sh logout &
fi
if [[ $res = *"Suspend"* ]]; then
    ~/.config/i3/scripts/graceful_shutdown.sh suspend &
fi
if [[ $res = *"Restart"* ]]; then
    ~/.config/i3/scripts/graceful_shutdown.sh restart &
fi
if [[ $res = *"Shutdown"* ]]; then
    ~/.config/i3/scripts/graceful_shutdown.sh shutdown &
fi
exit 0
