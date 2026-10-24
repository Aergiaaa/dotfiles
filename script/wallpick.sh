dir="${1:-$HOME/pict}"
[ -d "$dir" ] || {
  printf 'wallpick: no such dir: %s\n' "$dir" >&2
  exit 1
}

file=$(nsxiv -t -r -o -N wallpick "$dir")
[ -n "$file" ] || exit 0
feh --bg-fill "$file"
