#!/bin/bash

cd $(dirname "$0")

#include API_KEY
source api_key

FILENAME="/tmp/screenshot.png"
chmod 644 $FILENAME
RANDOMNAME=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 10)

RESULT=$(curl -s -H "Authorization: Bearer $API_KEY" -F "file=@/tmp/screenshot.png" https://upload.patrick115.eu/api/upload)
SUCCESS=$( echo "$RESULT" | jq -r '.status')

if [[ $SUCCESS == "true" ]]; then
    URL=$(echo "$RESULT" | jq -r '.data')
    echo $URL | wl-copy
    notify-send -t 5000 -u low -i /tmp/screenshot.png "Image uploader" "Screenshot has been uploaded"
else
    notify-send -t 5000 -u critical -i /tmp/screenshot.png "Image uploader" "Screenshot upload failed"
    exit 1
fi
