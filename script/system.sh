#!/bin/sh

cputemp=$(sensors k10temp-pci-00c3 | awk '/^Tctl/ {print $2}' | sed -E 's/^\+([0-9]+)\.?[0-9]*/\1/')
memperc=$(free -m | awk '/^Mem/ {print ($3)/($2)}' | sed -E 's/0\.([0-9]{2})([0-9]).*/\1.\2%/')
cpuuse=$(top -bn1 | grep "Cpu(s)" | awk '{print "u="$2"%s="$4"%"}')
gpuuse=$(timeout 3 radeontop -d - -l1 | awk -F, 'NR==2 {print $2}' | awk '{print $2}')

[ -z "$gpuuse" ] && gpuuse="Nan%"

echo $gpuuse:$memperc:$cpuuse"t="$cputemp
