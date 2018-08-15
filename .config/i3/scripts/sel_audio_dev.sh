#!/bin/bash

res=$(echo "	Headphone;	Speakers" | rofi -sep ";" -dmenu -p "Select audio device:" -hide-scrollbar -i -theme AudioSelMenu)

if [[ "$res" = *"Headphone"* ]]
then
	pacmd set-card-profile alsa_card.pci-0000_00_1b.0 output:iec958-stereo
	while read -r line
	do 
		if [[ "$line" = *"iec958-stereo"* ]] 
		then
			name=${line##* <}
			name=${name%>*}
			echo $name
			pacmd set-default-sink $name
			break
		fi
	done <<<$(pacmd list-sinks)
fi

if [[ $res = *"Speakers"* ]]
then
	pacmd set-card-profile alsa_card.pci-0000_00_1b.0 output:analog-stereo+input:analog-stereo
	while read -r line
	do 
		if [[ "$line" = *"alsa_output.pci-0000_00_1b.0.analog-stereo"* ]] 
		then
			name=${line##* <}
			name=${name%>*}
			echo $name
			pacmd set-default-sink $name
			break
		fi
	done <<<$(pacmd list-sinks)
fi
exit 0
