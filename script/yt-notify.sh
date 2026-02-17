#!/bin/sh

CHAN_ID="${1:?Usage: $0 <channel_id>}"
INTERVAL=60
FEED_URL="https://www.youtube.com/feeds/videos.xml?channel_id=$CHAN_ID"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/yt-notify"
SEEN_FILE="$CACHE_DIR/$CHAN_ID.seen"

mkdir -p "$CACHE_DIR"
touch "$SEEN_FILE"

echo "listening to $CHAN_ID every 60s"

while true; do
  XML=$(curl -sf --max-time 10 "$FEED_URL" || {
    sleep "$INTERVAL"
    continue
  })

  CHANNEL_NAME=$(echo "$XML" | grep -oP '(?<=<author><name>)[^<]+' | head -1)

  VIDEO_IDS=$(echo "$XML" | grep -oP '(?<=<yt:videoId>)[^<]+')
  TITLES=$(echo "$XML" | grep -oP '(?<=<media:title>)[^<]+')

  paste <(echo "$VIDEO_IDS") <(echo "$TITLES") | while IFS=$'\t' read -r VID TITLE; do
    if ! grep -qxF "$VID" "$SEEN_FILE"; then
      echo "$VID" >>"$SEEN_FILE"

      PAGE=$(curl -sf --max-time 10 "https://www.youtube.com/watch?v=$VID" || true)
      if echo "$PAGE" | grep -q '"isLive":true'; then
        LABEL="LIVE"
      else
        LABEL="New video"
      fi

      notify-send --urgency=normal "$LABEL — $CHANNEL_NAME" \
        "$TITLE\nhttps://youtu.be/$VID"

      echo "[$LABEL] $TITLE ($VID)"
    fi
  done

  sleep "$INTERVAL"
done
