#!/bin/bash

if [ -f /tmp/.move_workspaces.lock ]; then
    for i in {1..4}
    do
        hyprctl dispatch moveworkspacetomonitor $i eDP-1
        eww open bar --screen 0
    done
    rm /tmp/.move_workspaces.lock
else
    for i in {1..4}
    do
        hyprctl dispatch moveworkspacetomonitor $i HDMI-A-1
        eww open bar --screen 1
    done
    touch /tmp/.move_workspaces.lock
fi