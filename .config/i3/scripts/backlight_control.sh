#! /bin/bash

BRIGHTNESS_FILE=/sys/class/backlight/gmux_backlight/brightness
BRIGHT_CONF_DIR="$HOME/.brightgmux"
LAST_BRIGHT_FILE="${BRIGHT_CONF_DIR}/last_bright"

BRIGHTNESS=$(<$BRIGHTNESS_FILE)
MAX_BRIGHTNESS=$(</sys/class/backlight/gmux_backlight/max_brightness)

while getopts "idslh" optname
    do
        case "$optname" in
            "i")
            # Increase brightness by step
            BRIGHTNESS=$(((($MAX_BRIGHTNESS*$2)/100)+$BRIGHTNESS))
            if (($BRIGHTNESS>$(($MAX_BRIGHTNESS))))
            then
                BRIGHTNESS=$MAX_BRIGHTNESS
            fi
            ;;
            "d")
            # Decrease brightness by step
            BRIGHTNESS=$(($BRIGHTNESS-(($MAX_BRIGHTNESS*$2)/100)))
            if (($BRIGHTNESS<100))
            then
                BRIGHTNESS=$((100))
            fi
            ;;
            "l")
            # Loads brightness
            echo "Loading last value of brightness."
            # Loads last value, saved in file last_bright
            BRIGHT=$(<$LAST_BRIGHT_FILE)
            echo "Last value of brightness was: $BRIGHTNESS"
            ;;
            "s")
            # Sets brightness to specific value
            BRIGHTNESS=$2
            if (($BRIGHTNESS>$MAX_BRIGHTNESS))
            then
                BRIGHTNESS=$MAX_BRIGHTNESS
            fi

            if (($BRIGHTNESS<100))
            then
                BRIGHTNESS=$((100))
            fi
            ;;
            "h")
            echo "Help: "
            echo "-i    Increase brightness"
            echo "-d    Decrease brightness"
            echo "-l    Load last brightness value"
            echo "-s N  Set to custom value"
            echo "-h    This help"
            exit 0;
            ;;
            "?")
            echo "Unknown argument, try bright -h for help"
            exit 1;
            ;;
            *)
            # Should not occur
            echo "Unknown error while processing options"
            exit 2;
            ;;
        esac
    done

echo "Brightness set on $BRIGHTNESS"
# Save variable BRIGHTNESS into file brightness
echo $BRIGHTNESS > ${BRIGHTNESS_FILE}
# Save variable BRIGHTNESS into file last_bright
if [ ! -d ${BRIGHT_CONF_DIR} ] ; then mkdir ${BRIGHT_CONF_DIR} ; fi
echo $BRIGHTNESS > ${LAST_BRIGHT_FILE}
