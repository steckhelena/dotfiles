export DEFAULT_NETWORK_INTERFACE=`ip route | grep '^default' | awk '{print $5}' | head -n1`
export GTK_THEME="Kanagawa-Borderless"
