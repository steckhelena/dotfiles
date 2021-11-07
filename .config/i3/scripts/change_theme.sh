#!/bin/bash

current_filename=~/.current_pybase16_theme

# recover currently selected theme
current=$(cat $current_filename 2>/dev/null || echo '(not initialized)');

# list themes
themes=$(find ~/.config/pybase16/schemes/ -regextype posix-extended -regex '.*\.yaml|.*\.yml' -type f  \
        | xargs -n1 basename \
        | sed 's/\.yaml$\|\.yml$//' \
        | sort \
        | sed -z 's/\n/|/g;s/|$/\n/')

res=$(echo $themes | \
      rofi -no-fixed-num-lines -sep '|' -dmenu -i \
      -p "Select the theme - current: $current" \
      -theme ThemeMenu)

if [[ "$res" ]]; then
    (cd ~/.config/pybase16;
    pybase16 inject -s $res -f ../kitty/theme.conf -f ../nvim/theme.vim -f ../polybar/config -f ../rofi/config.rasi -f ../i3/config -f ~/.themes/FlatColor/colors2 -f ~/.themes/FlatColor/colors3)

    echo $res > $current_filename
    i3-msg reload
    kitty @ set-colors --all --configured ~/.config/kitty/kitty.conf
    killall -HUP xsettingsd
fi

