#!/bin/bash
FILENAME="/tmp/screenshot.png"
chmod 644 $FILENAME
RANDOMNAME=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 10)
scp $FILENAME images:/var/www/patrick115.eu/upload/.storage/$RANDOMNAME.png
echo "https://upload.patrick115.eu/screenshot/$RANDOMNAME.png" | wl-copy
notify-send -t 5000 -u low "Screenshot has been uploaded"