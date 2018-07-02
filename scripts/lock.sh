#!/bin/sh

icon=$HOME/.config/scripts/lock.png
tmpbg=$HOME/tmp/xscreensaver/locked.png

[ $# -eq 0 ] || icon=$1

# Stop spotify if running
gdbus call --session \
	--dest org.mpris.MediaPlayer2.spotify \
	--object-path /org/mpris/MediaPlayer2 \
	--method org.mpris.MediaPlayer2.Player.Stop 2>&1 >/dev/null

scrot $tmpbg
convert $tmpbg -scale 10% -scale 1000% $tmpbg
convert $tmpbg $icon -gravity center -composite -matte $tmpbg
i3lock -i $tmpbg
