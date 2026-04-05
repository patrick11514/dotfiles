#!/bin/bash

#load as arg
MONITOR_NAME=$1

if [ -z "$MONITOR_NAME" ]; then
    echo "Usage: $0 <monitor_name>"
    exit 1
fi

# check if temp file exists
TEMP_FILE="/tmp/monitor_$MONITOR_NAME.state"

# 1. The Configuration Map
case "$MONITOR_NAME" in
    "HDMI-A-1") PARAMS="1920x1080@60, 0x180, 1" ;;
    "DP-1")     PARAMS="2560x1440@240, 1920x0, 1" ;;
    "HDMI-A-2") PARAMS="1920x1080@60, 4480x180, 1" ;;
    *)
        echo "Error: Monitor '$MONITOR_NAME' not found in configuration map."
        exit 1
        ;;
esac

# 2. The Toggling Logic
if [ -f "$TEMP_FILE" ]; then
    # Re-attach the monitor using the mapped parameters
    hyprctl keyword monitor "$MONITOR_NAME,$PARAMS"
    rm "$TEMP_FILE"
    echo "$MONITOR_NAME re-enabled at $PARAMS"
else
    # Completely sever the monitor from the layout
    hyprctl keyword monitor "$MONITOR_NAME,disable"
    touch "$TEMP_FILE"
    echo "$MONITOR_NAME completely disabled"
fi
