picom -b &

feh --bg-fill ~/pict/memship_wp/*June*2026.png 

dwmblocks &

dunst &

mpd &

slock -m "LOCKED" &

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
	eval "$(ssh-agent)"
fi

/usr/lib/xfce-polkit/xfce-polkit &

(sleep 2 && input-remapper-control --command autoload) &

xset s off
xset s noblank
xset -dpms &

xrdb -merge ~/.Xresources &
xrdb -merge ~/.cache/wal/colors.Xresources &

exec dwm > ~/.dwm.log 2>&1
