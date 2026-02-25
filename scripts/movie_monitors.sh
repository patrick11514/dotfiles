#!/bin/bash

if [ ! -f /tmp/.movielock ]; then
    hyprctl dispatch dpms off HDMI-A1
    hyprctl dispatch dpms off HDMI-A2
    touch /tmp/.movielock
else
    hyprctl dispatch dpms on HDMI-A1
    hyprctl dispatch dpms on HDMI-A2
    rm /tmp/.movielock
fi
