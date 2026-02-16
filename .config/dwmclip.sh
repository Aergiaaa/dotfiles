#!/usr/bin/env bash

hist="$HOME/.cache/cliphist"
plchold="<NEWLINE>"

highlight()	{
	clip=$(xclip -o -selection primary | xclip -i -f -selection clipboard 2>/dev/null);
}

output() {
	clip=$(xclip -i -f -selection clipboard 2>/dev/null)
}

write() {
	[ -f "$hist" ] 	|| notify-send "Creating $hist"; touch $hist
	[ -z "$clip" ] && exit 0

	multiline=$(echo "$clip" | sed ':a;N;$!ba;s/\n/'"$plchold"'\g')
	grep -Fxq "$multiline" "$hist" || echo "$multiline" >> "$hist"
	notify=$(echo \"$multiline\")
}

sel() {
	select=$(tac "$hist" | dmenu -b -l 5 -i -p "Clip Hist:")
	[ -n "$select" ] && echo "$select" | sed "s/$plchold/\n/g" |
		xclip -i -selection clipboard && notify="Copied to clip!"
}

case "$1" in
	add) highlight && write ;;
	out) output && write ;;
	sel) sel ;;
	*) printf "$0 | File $hist\n\nadd - copies primary selection to
		clip, and adds to hist file\nout - pipe cmd to copy output to 
		clip, and adds to hist file\n sel - select from hist file with dmenu\n" ; exit 0 ;;
esac

notify-send -h string:fgcolor:#87CEEB "$notify"



