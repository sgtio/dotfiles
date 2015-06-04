#!/bin/bash
zenity --question --text "Are you sure you want to shutdown?" && systemctl poweroff
