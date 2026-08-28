#!/bin/bash

# Define the path to your sub-utility
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOGGLE_SCRIPT="$SCRIPT_DIR/toggle_monitor.sh"

# Toggle both side monitors using the centralized map and state logic
"$TOGGLE_SCRIPT" HDMI-A-1
"$TOGGLE_SCRIPT" HDMI-A-2

echo "Movie mode toggled."
