#!/bin/bash

if [ -f /tmp/.movielock ]; then
    hyprctl dispatch dpms on DP-1
else
    hyprctl dispatch dpms on
fi
