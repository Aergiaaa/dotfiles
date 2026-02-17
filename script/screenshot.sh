file="$HOME/pict/ss/$(date +%d-%H-%M).jpg"
scrot -s -q 100 -l mode=edge $file
xclip -selection clipboard -t image/jpeg i $file
