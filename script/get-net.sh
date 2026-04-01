#!/bin/bash

stats=$(nmcli -t -f GENERAL.TYPE,GENERAL.STATE d show)

wifi_state=$(echo "$stats" | grep -A1 "GENERAL.TYPE:wifi$" | grep "GENERAL.STATE" | grep -o '^[^:]*:[0-9]*' | grep -o '[0-9]*$')
eth_state=$(echo "$stats" | grep -A1 "GENERAL.TYPE:ethernet" | grep "GENERAL.STATE" | grep -o '^[^:]*:[0-9]*' | grep -o '[0-9]*$')

state=
output=

if [ "$eth_state" = "100" ]; then
  state="eth"
elif [ "$wifi_state" = "100" ]; then
  state="wf"
else
  state="off"
fi

to_bytes() {
  local val="$1"
  local num suffix
  num=$(echo "$val" | grep -o '^[0-9.]*')
  suffix=$(echo "$val" | grep -o '[A-Za-z]*$')
  case "$suffix" in
  K | k) echo $(awk "BEGIN{printf \"%d\", $num * 1024}") ;;
  M | m) echo $(awk "BEGIN{printf \"%d\", $num * 1048576}") ;;
  G | g) echo $(awk "BEGIN{printf \"%d\", $num * 1073741824}") ;;
  *) echo $(awk "BEGIN{printf \"%d\", $num}") ;;
  esac
}

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
  downstat=$(to_bytes "$(echo $netstats | awk '{print $1}')")
  upstat=$(to_bytes "$(echo $netstats | awk '{print $2}')")

  output+="d="
  if [ $downstat -gt 1024 ]; then
    dkilo=$((downstat / 1024))

    if [ $dkilo -gt 1024 ]; then
      dmega=$((dkilo / 1024))
      output+="${dmega}Mb:"
    else
      output+="${dkilo}Kb:"
    fi
  else
    output+="${downstat}b:"
  fi

  output+="u="
  if [ $upstat -gt 1024 ]; then
    ukilo=$((upstat / 1024))

    if [ $ukilo -gt 1024 ]; then
      umega=$((ukilo / 1024))
      output+="${umega}Mb"
    else
      output+="${ukilo}Kb"
    fi
  else
    output+="${upstat}b"
  fi

  output+="[$state]"
else
  output+="[$state]"
fi

echo "$output"
exit 0
