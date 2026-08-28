#!/bin/bash

if [ -f /tmp/.movielock ]; then
    hyprctl dispatch 'hl.dsp.dpms({ action = "on", monitor = "DP-1" })'
else
    hyprctl dispatch 'hl.dsp.dpms({ action = "on" })'
fi
