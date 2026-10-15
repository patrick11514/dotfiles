#!/bin/bash

if [ -f /tmp/.movielock ]; then
    hyprctl dispatch 'hl.dsp.dpms({ action = "enable", monitor = "DP-1" })' 2>/dev/null || hyprctl dispatch dpms on DP-1
else
    hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })' 2>/dev/null || hyprctl dispatch dpms on
fi
