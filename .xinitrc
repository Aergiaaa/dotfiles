xset s off -dpms &

picom -b &

wal -i ~/pict/memship_wp/*June*without*&

dwmblocks &

slock -m "LOCKED" &

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
	eval "$(ssh-agent)"
fi

(sleep 2 && input-remapper-control --command autoload) &

exec dwm
