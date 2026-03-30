#!/bin/bash

# Fixed interface names
wifi_iface="wlp1s0"
eth_iface="enp3s0f3u2u4"

# Parse nmcli: each device block has TYPE and STATE on their own lines
stats=$(nmcli -t -f GENERAL.TYPE,GENERAL.STATE d show)

wifi_state=$(echo "$stats" | awk -F: '/GENERAL.TYPE:wifi$/{found=1} found && /GENERAL.STATE/{match($0,/[0-9]+/); print substr($0,RSTART,RLENGTH); exit}')
eth_state=$(echo "$stats"  | awk -F: '/GENERAL.TYPE:ethernet/{found=1} found && /GENERAL.STATE/{match($0,/[0-9]+/); print substr($0,RSTART,RLENGTH); exit}')

if [ "$wifi_state" = "100" ]; then
  state="wf"
  iface="$wifi_iface"
elif [ "$eth_state" = "100" ]; then
  state="eth"
  iface="$eth_iface"
else
  state="off"
fi

# Helper: format bytes into human-readable
fmt() {
  local b=$1
  if [ "$b" -ge 1048576 ]; then
    echo "$(( b / 1048576 ))M"
  elif [ "$b" -ge 1024 ]; then
    echo "$(( b / 1024 ))K"
  else
    echo "${b}B"
  fi
}

# Default: just show connection state
if [ -z "$BLOCK_BUTTON" ] || [ "$state" = "off" ]; then
  case $state in
    wf)  echo " wf"  ;;
    eth) echo " eth" ;;
    *)   echo " off" ;;
  esac
  exit 0
fi

# Clicked: measure download/upload speed via /proc/net/dev
get_bytes() {
  awk -v iface="$iface:" '$1==iface {print $2, $10}' /proc/net/dev
}

read rx1 tx1 <<< $(get_bytes)
sleep 1
read rx2 tx2 <<< $(get_bytes)

if [ -z "$rx1" ] || [ -z "$rx2" ]; then
  echo " no data"
  exit 0
fi

dl=$(( rx2 - rx1 ))
ul=$(( tx2 - tx1 ))

echo " dw=$(fmt $dl)/s up=$(fmt $ul)/s [$state]"
