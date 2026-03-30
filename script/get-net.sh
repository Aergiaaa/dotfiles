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
    netstats=$(ifstat | awk '/wlp1s0/{print $6, $8}')
    ;;
  eth)
    netstats=$(ifstat | awk '/enp3s0f3u2u4/{print $6, $8}')
    ;;
  esac

  if [ -n "$netstats" ]; then
    downstat=$(echo $netstats | awk '{print $1}')
    upstat=$(echo $netstats | awk '{print $2}')

    if [ $downstat -gt 1024 ]; then
      dkilo=$((downstat / 1024))

      if [ $dkilo -gt 1024 ]; then
        dmega=$((dkilo / 1024))
        output+="dw=${dmega}Mb:"
      else
        output+="dw=${dkilo}Kb:"
      fi
    else
      output+="dw=${downstat}b:"
    fi

    if [ $upstat -gt 1024 ]; then
      ukilo=$((upstat / 1024))

      if [ $ukilo -gt 1024 ]; then
        umega=$((ukilo / 1024))
        output+="up=${umega}Mb"
      else
        output+="up=${ukilo}Kb"
      fi
    else
      output+="up=${upstat}b"
    fi

    output+="[$state]"
  else
    output+="[$state]"
  fi

  echo "$output"
  exit 0
