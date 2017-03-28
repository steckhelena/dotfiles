#! /bin/bash

trap 'echo "ignoring sigterm"' SIGTERM

gracefully="spotify|atom"

ps ax | egrep $gracefully | cut -b1-06 | xargs -t kill

for s in 2 1
do
    sleep 1
done

if [ $1 = "logout" ]; then
    i3-msg exit
fi
if [ $1 = "suspend" ]; then
    systemctl suspend
fi
if [ $1 = "restart" ]; then
    systemctl reboot
fi
if [ $1 = "shutdown" ]; then
    systemctl poweroff
fi
