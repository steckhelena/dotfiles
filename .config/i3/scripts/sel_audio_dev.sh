#!/bin/bash

res=$(echo "	Headphone;	Speakers" | rofi -sep ";" -dmenu -p "Select audio device:" -i -theme AudioSelMenu)

if [[ "$res" = *"Headphone"* ]]
then
	pactl set-card-profile alsa_card.usb-Astro_Gaming_Astro_A50-00 output:stereo-game+output:stereo-chat+input:mono-chat
	while read -r line
	do 
		if [[ "$line" = *"alsa_output.usb-Astro_Gaming_Astro_A50-00.stereo-game"* ]] 
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
	pactl set-card-profile alsa_card.pci-0000_00_1b.0 output:analog-stereo+input:analog-stereo
	while read -r line
	do 
		if [[ "$line" = *"alsa_output.pci-0000_00_1b.0.analog-stereo"* ]] 
		then
			name=${line##Name:}
			echo $name
			pactl set-default-sink $name
			break
		fi
	done <<<$(pactl list sinks)
fi
exit 0
