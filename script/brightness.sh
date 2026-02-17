opt=$1
scale=$2

case $opt in
"up")
  brightnessctl set $scale%+
  ;;
"down")
  brightnessctl set $scale%-
  ;;
esac

pkill -RTMIN+2 dwmblocks
