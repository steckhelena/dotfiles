#!/bin/bash

# constants
readonly POLYBAR_CONFIG_DIR=~/.cache
readonly POLYBAR_NETWORK_IFACE_FILE=${POLYBAR_CONFIG_DIR}/polybar_net_iface

# create polybar network config file if it does not exist
if [[ ! -e ${POLYBAR_NETWORK_IFACE_FILE} ]]; then
    mkdir -p ${POLYBAR_CONFIG_DIR}
    DEFAULT_NETWORK_INTERFACE=`ip route | grep '^default' | awk '{print $5}' | head -n1`
    echo ${DEFAULT_NETWORK_INTERFACE} > $POLYBAR_NETWORK_IFACE_FILE
fi

# list network devices
network_devices=$(ip -j link | \
                  jq -r '[.[].ifname | select(. != "lo")] | join("|")')

# select network devices using rofi
res=$(echo $network_devices | \
      rofi -no-fixed-num-lines -sep '|' -dmenu -p "Select network device:" \
      -i -theme NetworkCardSelMenu)

# selected a new device
if [[ "$res" ]]; then
    # write file with selected network device
    echo "$res" > ${POLYBAR_NETWORK_IFACE_FILE}

    # restart polybar instance to change network device
    polybar-msg cmd restart
fi
