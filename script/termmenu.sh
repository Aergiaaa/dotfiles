font="FiraCode Nerd Font:style=Medium:size=20"
col_gray="#222222"
col_fonts="#bbbbbb"
col_fonth="#222222"
col_main="#46648C"

dmenu_set() {
  dmenu -p "on term" -fn "$font" -nb "$col_gray" -nf "$col_fonts" -sb "$col_main" -sf "$col_fonth" -l 7
}

dmenu_path |
  dmenu_set |
  xargs -I{} st -e sh -c '{} || { echo; printf "Press Enter to close"; read -r; }'
