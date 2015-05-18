#!/bin/bash

ACTION=`zenity --width=90 --height=200 --list --radiolist --text="Select logout action" --title="Logout" --column "Choice" --column "Action" TRUE Shutdown FALSE Reboot FALSE LogOut FALSE LockScreen FALSE Suspend`

if [ -n "${ACTION}" ];then
  case $ACTION in
  Shutdown)
      systemctl halt
      ;;
  Reboot)
      systemctl reboot
      ;;
  LogOut)
      echo "awesome.quit()" | awesome-client
      ;;
  Suspend)
    #dbus-send --system --print-reply --dest=org.freedesktop.Hal \
    #/org/freedesktop/Hal/devices/computer \
    #org.freedesktop.Hal.Device.SystemPowerManagement.Suspend int32:0
    # HAL is deprecated in newer systems in favor of UPower etc.
      systemctl suspend 
      ;;
  LockScreen)
    /home/sejo/.config/dotfiles/scripts/lock.sh
    # Or gnome-screensaver-command -l
    ;;
  esac
fi
