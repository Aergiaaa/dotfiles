procname=$(ps aux | awk 'NR>1 {print $11;}' | dmenu -l 10 -p "kill what")

if [ -z "$procname" ]; then
  echo "Halted"
  exit 0
fi

procid=$(pgrep "$procname")

echo "Name:" "$procname"
echo "Id:" "$procid"
