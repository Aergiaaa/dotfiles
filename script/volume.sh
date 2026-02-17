#!/bin/sh

opt=$1
scale=$2

case $opt in
	"up")
		wpctl set-volume @DEFAULT_AUDIO_SINK@ $scale%+
		;;
	"down")
		wpctl set-volume @DEFAULT_AUDIO_SINK@ $scale%-
		;;
	"mute")
		wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
		;;
esac

pkill -RTMIN+1 dwmblocks
