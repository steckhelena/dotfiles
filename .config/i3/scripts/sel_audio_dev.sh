#!/bin/bash

res=$(echo "	Headphone;	Speakers" | rofi -sep ";" -dmenu -p "Select audio device:" -i -theme AudioSelMenu)

if [[ "$res" = *"Headphone"* ]]
then
	pactl set-card-profile alsa_card.pci-0000_00_1b.0 output:iec958-stereo
	pactl set-card-profile alsa_card.usb-Astro_Gaming_Astro_A50-00 output:stereo-game+output:stereo-chat+input:mono-chat
	pactl set-default-source alsa_input.usb-Astro_Gaming_Astro_A50-00.mono-chat
	while read -r line
	do 
		if [[ "$line" = *"iec958"* ]] 
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
