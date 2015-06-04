#!/bin/bash
zenity --question --text "Are you sure you want to log out?" && echo 'awesome.quit()' | awesome-client
