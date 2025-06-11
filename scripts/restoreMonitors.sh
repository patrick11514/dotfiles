#!/bin/bash

if [ -f /tmp/.movielock ]; then
    hyprctl dispatch dpms on DP-2
else
    hyprctl dispatch dpms on
fi
