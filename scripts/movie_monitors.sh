#!/bin/bash

# Define the path to your new sub-utility
TOGGLE_SCRIPT="/home/patrick115/scripts/toggle_monitor.sh"

# Toggle both side monitors using the centralized map and state logic
$TOGGLE_SCRIPT HDMI-A-1
$TOGGLE_SCRIPT HDMI-A-2

echo "Movie mode toggled."
