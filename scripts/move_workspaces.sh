#!/bin/bash

if [ -f /tmp/.move_workspaces.lock ]; then
    rm /tmp/.move_workspaces.lock

    ln -sf ~/.config/hypr/rules/single.conf ~/.config/hypr/rules.conf
    hyprctl reload

    hyprctl --batch "$(
        for i in {1..10}; do printf "dispatch moveworkspacetomonitor %s eDP-1;" $i; done
    )"

    hyprctl dispatch movetoworkspace 5,class\:\(discord\)
    hyprctl dispatch movetoworkspace 4,class\:\(Slack\)

    eww open bar --screen 0
else
    touch /tmp/.move_workspaces.lock

    ln -sf ~/.config/hypr/rules/dual.conf ~/.config/hypr/rules.conf
    hyprctl reload


    hyprctl --batch "$(
        for i in {1..8}; do printf "dispatch moveworkspacetomonitor %s HDMI-A-1;" $i; done
        for i in {9..10}; do printf "dispatch moveworkspacetomonitor %s eDP-1;" $i; done
    )"

    hyprctl dispatch movetoworkspace 9,class\:\(discord\)
    hyprctl dispatch movetoworkspace 10,class\:\(Slack\)

    eww open bar --screen 1
fi