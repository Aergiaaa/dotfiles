#!/bin/sh

cputemp=$(sensors k10temp-pci-00c3 | awk '/^Tctl/ {print $2}' | sed -E 's/^\+([0-9]+)\.?[0-9]*/\1/')
memperc=$(free -m | awk '/^Mem/ {print ($3)/($2)}' | sed -E 's/0\.([0-9]{2})([0-9]).*/\1%/')
cpuuse=$(top -bn1 | grep "Cpu(s)" | awk '{sum=$2+$4;print sum"%"}' | sed 's/\.[0-9]*//')
gpuuse=$(timeout 3 radeontop -d - -l1 | awk -F, 'NR==2 {print $2}' | awk '{print $2}' | sed 's/\.[0-9]*//')

[ -z "$gpuuse" ] && gpuuse="Nan%"

result=""
system=($gpuuse $memperc $cpuuse)
for item in "${system[@]}";do
	num="${item%\%}"

	if [[ "$num" -ge 80 ]]; then
		result+="$item!:"
		continue
	fi

	result+="$item:"
done

echo -e "$result$cputemp"
