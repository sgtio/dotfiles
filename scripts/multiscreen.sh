#!/usr/bin/env bash


singleFlag=0
conkyFlag=0
wallpaperFlag=0
pos='--right-of'

while getopts 'scwalrb' OPTION
do
    case $OPTION in
	s) singleFlag=1;;
	c) conkyFlag=1;;
	w) wallpaperFlag=1;;
	a) pos='--above';;
	l) pos='--left-of';;
	r) pos='--right-of';;
	b) pos='--below';;
	?) echo "Usage: $0 [-scw]";;
    esac
done

vga=$(xrandr | grep 'VGA1 connected' -o)

if [ -n "$vga" ]
then
    vgaRes=$(xrandr | grep VGA --after-context=1 | tail -1 | awk '{print $1}')
else
    vgaRes=0
fi

if [ $singleFlag -eq 1 ]
then
    if [ -n "$vga" ]
    then
	echo "Connecting external display only"
	xrandr --output VGA1 --mode $vgaRes
	xrandr --output LVDS1 --off
    else
	echo "Connecting laptop display only"
	xrandr --output LVDS1 --mode 1366x768
    fi

else
    if [ -n "$vga" ]
    then
	xrandr --output LVDS1 --mode 1366x768
	xrandr --output VGA1 --mode $vgaRes $pos LVDS1
    else
	xrandr --output LVDS1 --mode 1366x768
    fi
fi

if [ $conkyFlag -eq 1 ]
then
    echo "Restarting conky"
    pkill conky
    conky -c $HOME/.config/dotfiles/conky/conkyrc
fi

if [ $wallpaperFlag -eq 1 ]
then
    echo "Running wallpaper script"
    feh --bg-fill /home/sejo/Pictures/chamber.jpg
fi
