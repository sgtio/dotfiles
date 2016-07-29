#!/bin/bash
icon="$HOME/.config/i3/scripts/lock.png"
tmpbg="$HOME/tmp/xscreensaver/locked.png"

(( $# )) && { icon=$1; }

playerctl stop
scrot "$tmpbg"
convert "$tmpbg" -scale 10% -scale 1000% "$tmpbg"
convert "$tmpbg" "$icon" -gravity center -composite -matte "$tmpbg"
xscreensaver-command -lock 
