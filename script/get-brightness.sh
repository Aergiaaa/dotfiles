#!/bin/sh

bright=$(brightnessctl g)
max_bright=$(brightnessctl m)

perc=$((bright * 100 / max_bright))

echo "br: $perc%"
