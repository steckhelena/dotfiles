#!/bin/bash

set -e

res=$(echo "	Headphone;	Speakers;󰡁	HDMI" | rofi -sep ";" -dmenu -p "Select audio device:" -i -theme AudioSelMenu)


pactl set-card-profile alsa_card.usb-Blue_Microphones_Yeti_X_2119SG002298_888-000313110306-00 input:iec958-stereo

while read -r line
do 
	if [[ "$line" = *"Yeti"*"iec958"* ]] 
	then
		name=${line##Name: }
		echo $name
		pactl set-default-source $name
		break
	fi
done <<<$(pactl list sources)

if [[ "$res" = *"Headphone"* ]]
then
	pactl set-card-profile bluez_card.88_C9_E8_68_B2_26 a2dp-sink
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
	pactl set-card-profile alsa_card.usb-Generic_USB_Audio_200901010001-00 HiFi
	pactl set-card-profile alsa_card.usb-Generic_USB_Audio-00 'HiFi 5+1'
	pactl set-default-sink `pactl list sinks \
		| grep -Ei -B2 'description:.*(spdif|s/pdif|optical)' \
		| grep -Ei -C1 '(idle|running)' \
		| grep -i 'name:' \
		| grep -v '^--$' \
		| awk '{print $2}' \
		| tail -n1`
fi
if [[ $res = *"HDMI"* ]]
then
	pactl set-card-profile alsa_card.pci-0000_03_00.1 output:hdmi-stereo
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
