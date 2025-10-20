#!/bin/bash

if [ -f /tmp/.move_workspaces.lock ]; then
    rm /tmp/.move_workspaces.lock

    ln -sf ~/.config/hypr/rules/single.conf ~/.config/hypr/rules.conf
    hyprctl reload

    for i in {1..8}
    do
        hyprctl dispatch moveworkspacetomonitor $i eDP-1
    done

    hyprctl dispatch movetoworkspace 5,class\:\(discord\)
    hyprctl dispatch movetoworkspace 4,class\:\(Slack\)

    eww open bar --screen 0
else
    touch /tmp/.move_workspaces.lock

    ln -sf ~/.config/hypr/rules/dual.conf ~/.config/hypr/rules.conf
    hyprctl reload

    for i in {1..8}
    do
        hyprctl dispatch moveworkspacetomonitor $i HDMI-A-1
    done
    for i in {9..10}
    do
        hyprctl dispatch moveworkspacetomonitor $i eDP-1
    done

    hyprctl dispatch movetoworkspace 9,class\:\(discord\)
    hyprctl dispatch movetoworkspace 10,class\:\(Slack\)

    eww open bar --screen 1
fi