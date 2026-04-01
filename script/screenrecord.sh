file="$HOME/pict/ss/$(date +%d-%H-%M).mp4"
if [ -f /tmp/ffmpeg_pid ]; then
  kill -INT $(cat /tmp/ffmpeg_pid) && rm /tmp/ffmpeg_pid
else
  ffmpeg -f x11grab -video_size 1920x1080 -framerate 30 -i :0.0 -f pulse -i default $file &
  echo $! >/tmp/ffmpeg_pid

fi

pkill -RTMIN+6 dwmblocks
