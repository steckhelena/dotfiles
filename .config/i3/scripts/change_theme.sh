#!/bin/bash

current_filename=$1/.current_pybase16_theme
config_dir=$1/.config
themes_dir=$config_dir/pybase16
kitty_conf=$config_dir/kitty/kitty.conf
gtk_config_dir=$1/.themes

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

    if [[ "$res" = "No" ]]; then
        exit 0;
    fi

    mkdir -p $themes_dir
    (cd $themes_dir; pybase16 update; pybase16 build)
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
    pybase16 inject -s $res -f $config_dir/kitty/theme.conf -f $config_dir/nvim/theme.vim \
    -f $config_dir/polybar/config -f $config_dir/rofi/config.rasi -f $config_dir/i3/config \
    -f $gtk_config_dir/FlatColor/colors2 -f $gtk_config_dir/FlatColor/colors3)

    echo $res > $current_filename
    i3-msg reload
    kitty @ --to 'unix:/tmp/mykitten' set-colors --all --configured $kitty_conf
    killall -HUP xsettingsd
fi

