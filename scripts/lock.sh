#!/bin/sh

icon=$HOME/.config/scripts/lock.png
tmpbg=$HOME/tmp/xscreensaver/locked.png

[ $# -eq 0 ] || icon=$1

# Stop spotify if running
gdbus call --session \
	-d org.mpris.MediaPlayer2.spotify \
	-o /org/mpris/MediaPlayer2 \
	-m org.mpris.MediaPlayer2.Player.Stop 2>&1 >/dev/null

# Pause dunst
killall -SIGUSR1 dunst

scrot $tmpbg
convert $tmpbg -scale 10% -scale 1000% $tmpbg
convert $tmpbg $icon -gravity center -composite -matte $tmpbg
i3lock -i $tmpbg -n

# Resume dunst
killall -SIGUSR2 dunst
