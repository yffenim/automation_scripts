#!/bin/bash

IPADDR=$(ip addr show | grep inet | head -1)
DNS=$(nmcli dev show | grep DNS)

cat << EOF 
"Hello $USER! Today's date is $(date)."
"The machine you are using is $(uname) at... $IPADDR for $HOSTNAME."
"The current users logged on are: $(who)"
EOF
