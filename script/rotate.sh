#!/bin/sh

direction=$1

echo $direction
xrandr --output eDP --rotate $direction

case $direction in
	"normal")
		feh --bg-fill ~/pict/memship_wp/*June*without*
		;;
	"left")
		feh --bg-fill ~/pict/memship_wp/rotated*
		;;
	"right")
		feh --bg-fill ~/pict/memship_wp/rotated*
		;;
esac
