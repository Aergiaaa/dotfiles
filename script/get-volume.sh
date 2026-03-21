#!/bin/sh

vol="wpctl get-volume @DEFAULT_AUDIO_SINK@"

volume=$($vol | awk '{print int($2*100)}')
muted=$($vol | grep -o MUTED)

if [ "$muted" = "MUTED" ]; then
	echo "v:m"
else
	if [ $volume -gt 100 ]; then
		echo "v:$volume%!"
	else
	echo "v:$volume%"
	fi
fi
