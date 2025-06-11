#!/bin/bash

if [ ! -f /tmp/.movielock ]; then
    hyprctl dispatch dpms off DP-1
    hyprctl dispatch dpms off DP-3
    touch /tmp/.movielock
else
    hyprctl dispatch dpms on DP-1
    hyprctl dispatch dpms on DP-3
    rm /tmp/.movielock
fi
