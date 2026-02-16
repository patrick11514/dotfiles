#!/bin/bash

#load as arg
MONITOR_NAME=$1

if [ -z "$MONITOR_NAME" ]; then
    echo "Usage: $0 <monitor_name>"
    exit 1
fi

# check if temp file exists
TEMP_FILE="/tmp/monitor_$MONITOR_NAME.state"

if [ -f "$TEMP_FILE" ]; then
    hyprctl dispatch dpms on "$MONITOR_NAME"
    rm "$TEMP_FILE"
    echo "$MONITOR_NAME turned ON"
else
    hyprctl dispatch dpms off "$MONITOR_NAME"
    touch "$TEMP_FILE"
    echo "$MONITOR_NAME turned OFF"
fi