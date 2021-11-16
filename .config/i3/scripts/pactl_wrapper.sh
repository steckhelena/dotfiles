#/bin/sh

curr_volume=`pactl get-sink-volume @DEFAULT_SINK@ | \
    grep -o '[0-9]*%' | \
    grep -o '[0-9]*' | \
    head -n1`

calculated_volume=`expr $curr_volume + $1`
limited_volume=$(( calculated_volume < 100 ? calculated_volume : 100 ))
limited_volume=$(( limited_volume > 0 ? limited_volume : 0 ))

pactl -- set-sink-volume @DEFAULT_SINK@ $limited_volume%
