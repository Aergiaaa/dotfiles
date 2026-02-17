#!/bin/sh

vol="wpctl get-volume @DEFAULT_AUDIO_SINK@"

volume=$($vol | awk '{print int($2*100)}')
muted=$($vol | grep -o MUTED)

if [ "$muted" = "MUTED" ]; then
	echo "vol: m"
else
	echo "vol: $volume%"
fi
