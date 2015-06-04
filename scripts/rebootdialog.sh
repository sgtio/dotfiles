#!/bin/bash
zenity --question --text "Are you sure you want to reboot?" && systemctl reboot
