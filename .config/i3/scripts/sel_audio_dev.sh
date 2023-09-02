#!/bin/bash

res=$(echo "	Headphone;	Speakers" | rofi -sep ";" -dmenu -p "Select audio device:" -i -theme AudioSelMenu)

if [[ "$res" = *"Headphone"* ]]
then
	pactl set-card-profile bluez_card.88_C9_E8_68_B2_26 a2dp-sink
	pactl set-card-profile alsa_card.usb-Blue_Microphones_Yeti_X_2119SG002298_888-000313110306-00 output:analog-stereo+input:iec958-stereo
	pactl set-default-source alsa_input.usb-Blue_Microphones_Yeti_X_2119SG002298_888-000313110306-00.analog-stereo.3
	while read -r line
	do 
		if [[ "$line" = *"bluez"* ]] 
		then
			name=${line##Name: }
			echo $name
			pactl set-default-sink $name
			break
		fi
	done <<<$(pactl list sinks)
fi

if [[ $res = *"Speakers"* ]]
then
	pactl set-card-profile alsa_card.pci-0000_00_1b.0 output:analog-stereo
	while read -r line
	do 
		if [[ "$line" = *"hdmi-stereo"* ]] 
		then
			name=${line##Name:}
			echo $name
			pactl set-default-sink $name
			break
		fi
	done <<<$(pactl list sinks)
fi
exit 0
