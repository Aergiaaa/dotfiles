file="$HOME/pict/ss/$(date +%d-%H-%M).mp4"
if [ -f /tmp/ffmpeg_pid ]; then
  pid=$(cat /tmp/ffmpeg_pid)
  kill -INT "$pid"
  wait "$pid" 2>/dev/null # <-- hold until ffmpeg fully exits
  rm /tmp/ffmpeg_pid
else
  ffmpeg -f x11grab -video_size 1920x1080 -framerate 30 -i :0.0 \
    -f pulse -i alsa_input.pci-0000_03_00.6.analog-stereo $file &
  echo $! >/tmp/ffmpeg_pid

fi

pkill -RTMIN+6 dwmblocks
