#!/bin/bash

stats=$(nmcli -t -f GENERAL.TYPE,GENERAL.STATE d show)

wifi_state=$(echo "$stats" | grep -A1 "GENERAL.TYPE:wifi$" | grep "GENERAL.STATE" | grep -o '^[^:]*:[0-9]*' | grep -o '[0-9]*$')
eth_state=$(echo "$stats" | grep -A1 "GENERAL.TYPE:ethernet" | grep "GENERAL.STATE" | grep -o '^[^:]*:[0-9]*' | grep -o '[0-9]*$')

state=
output=" "

if [ "$wifi_state" = "100" ]; then
  state="wf"
elif [ "$eth_state" = "100" ]; then
  state="eth"
else
  state="off"
fi

netstats=
case $state in
wf)
  netstats=$(ifstat | awk '/wlp1s0/{print $7, $9}')
  ;;
eth)
  netstats=$(ifstat | awk '/enp3s0f3u2u4/{print $7, $9}')
  ;;
esac

if [ -n "$netstats" ]; then
  downstat=$(echo $netstats | awk '{print $1}')
  upstat=$(echo $netstats | awk '{print $2}')

  output+="dw=$downstat""b:""up=$upstat""b:"
fi

output+="n=$state"

echo "$output"
