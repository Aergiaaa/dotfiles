if [[ $# -lt 2 ]]; then
  echo "Usage: $0 \"message\" hour <minute>"
  echo "Example: $0 \"Stream Started!\" 17 30"
  exit 1
fi

MESSAGE=$1
HOUR=$2
MINUTE="${3:-0}"

if ! [[ "$HOUR" =~ ^[0-9]+$ ]] || ! [[ "$MINUTE" =~ ^[0-9]+$ ]]; then
  echo "Error: hour and minute must be numbers"
  exit 1
fi

if ((HOUR < 0 || HOUR > 23)); then
  echo "Error: hour must be between 0 and 23"
  exit 1
fi
if ((MINUTE < 0 || MINUTE > 59)); then
  echo "Error: minute must be between 0 and 59"
  exit 1
fi

NOW_HOUR=$(date +%H)
NOW_MIN=$(date +%M)

if ((HOUR < NOW_HOUR || (HOUR == NOW_HOUR && MINUTE <= NOW_MIN))); then
  WHEN="tomorrow"
else
  WHEN="today"
fi

FORMATTED=$(printf "%02d:%02d" "$HOUR" "$MINUTE")

DISPLAY="${DISPLAY:-:0}"
BUS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=/run/user/$(id -u)/bus}"

JOB_SCRIPT="export DISPLAY='$DISPLAY'
	export DBUS_SESSION_BUS_ADDRESS='$BUS'
	notify-send --urgency=critical 'Alert' '$MESSAGE'"

JOB_OUTPUT=$(echo "$JOB_SCRIPT" | at "$FORMATTED $WHEN" 2>&1)

JOB_ID=$(echo "$JOB_OUTPUT" | grep -oP 'job \K[0-9]+')

echo "Alert set for $FORMATTED $WHEN"
