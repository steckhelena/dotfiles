#!/bin/bash

current_filename=~/.current_pybase16_theme
themes_dir=~/.config/pybase16

# recover currently selected theme
current=$(cat $current_filename 2>/dev/null || echo '(not initialized)');

# list themes
themes=$(find $themes_dir/schemes/ -regextype posix-extended -regex '.*\.yaml|.*\.yml' -type f  \
        | xargs -n1 basename \
        | sed 's/\.yaml$\|\.yml$//' \
        | sort \
        | sed -z 's/\n/|/g;s/|$/\n/')

if [[ -z "$themes" ]]; then
    echo $themes
    res=$(echo 'Yes|No' | \
        rofi -no-fixed-num-lines -sep '|' -dmenu -i \
          -p "Do you wish to install the themes?" \
          -theme YesNo)
    pip install pybase16-builder
    mkdir -p $themes_dir
    (cd $themes_dir; pybase16 update)
    res=$(echo 'Ok' | \
        rofi -sep '|' -dmenu -i \
          -p "Done!" -l 1\
          -theme YesNo)
    exit 0
fi

res=$(echo $themes | \
      rofi -no-fixed-num-lines -sep '|' -dmenu -i \
      -p "Select the theme - current: $current" \
      -theme ThemeMenu)

if [[ "$res" ]]; then
    (cd $themes_dir;
    pybase16 inject -s $res -f ../kitty/theme.conf -f ../nvim/theme.vim -f ../polybar/config -f ../rofi/config.rasi -f ../i3/config -f ~/.themes/FlatColor/colors2 -f ~/.themes/FlatColor/colors3)

    echo $res > $current_filename
    i3-msg reload
    kitty @ set-colors --all --configured ~/.config/kitty/kitty.conf
    killall -HUP xsettingsd
fi

