picom -b &

wal -i ~/pict/memship_wp/*June*without*&

dwmblocks &

dunst &

slock -m "LOCKED" &

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
	eval "$(ssh-agent)"
fi

/usr/lib/xfce-polkit/xfce-polkit &

(sleep 2 && input-remapper-control --command autoload) &

xset s off
xset s noblank
xset -dpms &

exec dwm > ~/.dwm.log 2>&1
