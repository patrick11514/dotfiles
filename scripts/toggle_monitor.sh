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
    "HDMI-A-1")
        MODE="1920x1080@60"
        POS="0x180"
        SCALE="1"
        ;;
    "DP-1")
        MODE="2560x1440@240"
        POS="1920x0"
        SCALE="1"
        ;;
    "HDMI-A-2")
        MODE="1920x1080@60"
        POS="4480x180"
        SCALE="1"
        ;;
    *)
        echo "Error: Monitor '$MONITOR_NAME' not found in configuration map."
        exit 1
        ;;
esac

# 2. The Toggling Logic
if [ -f "$TEMP_FILE" ]; then
    # Re-attach the monitor using the mapped parameters
    hyprctl eval "hl.monitor({ output = '$MONITOR_NAME', mode = '$MODE', position = '$POS', scale = $SCALE, disabled = false })" > /dev/null
    rm -f "$TEMP_FILE"
    echo "$MONITOR_NAME re-enabled at $MODE, $POS, $SCALE"
else
    # Completely sever the monitor from the layout
    hyprctl eval "hl.monitor({ output = '$MONITOR_NAME', disabled = true })" > /dev/null
    touch "$TEMP_FILE"
    echo "$MONITOR_NAME completely disabled"
fi
