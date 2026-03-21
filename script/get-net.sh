#!/bin/bash

stats=$(nmcli -t -f GENERAL.TYPE,GENERAL.STATE d show)

wifi_state=$(echo "$stats" | grep -A1 "GENERAL.TYPE:wifi$" | grep "GENERAL.STATE" | grep -o '^[^:]*:[0-9]*' | grep -o '[0-9]*$')
eth_state=$(echo "$stats" | grep -A1 "GENERAL.TYPE:ethernet" | grep "GENERAL.STATE" | grep -o '^[^:]*:[0-9]*' | grep -o '[0-9]*$')

output=" n:"
if [ "$wifi_state" = "100" ]; then
    output+="wf"
elif [ "$eth_state" = "100" ]; then
    output+="eth"
else
    output+="off"
fi

echo "$output"
