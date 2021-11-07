#!/bin/bash

# list network devices
themes=$(find ~/.config/pybase16/schemes/ -regextype posix-extended -regex '.*\.yaml|.*\.yml' -type f  \
        | xargs -n1 basename \
        | sed 's/\.yaml$\|\.yml$//' \
        | sort \
        | sed -z 's/\n/|/g;s/|$/\n/')

echo $themes

res=$(echo $themes | \
      rofi -no-fixed-num-lines -sep '|' -dmenu -i -p 'Select the theme')

if [[ "$res" ]]; then
    (cd ~/.config/pybase16;
    pybase16 inject -s $res -f ../kitty/theme.conf -f ../nvim/theme.vim -f ../polybar/config -f ../rofi/config.rasi -f ../i3/config -f ~/.themes/FlatColor/colors2 -f ~/.themes/FlatColor/colors3)

    i3-msg reload
    kitty @ set-colors --all --configured ~/.config/kitty/kitty.conf
    killall -HUP xsettingsd
fi

