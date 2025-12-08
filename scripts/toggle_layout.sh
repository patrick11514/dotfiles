#!/bin/bash

if [ -f /tmp/.home_layout.lock ]; then
    rm /tmp/.home_layout.lock

    ln -sf ~/.config/hypr/monitors/work.conf ~/.config/hypr/monitors.conf
    ln -sf ~/.config/hypr/rules/single.conf ~/.config/hypr/rules.conf
    hyprctl reload

    hyprctl --batch "$(
        for i in {1..10}; do printf "dispatch moveworkspacetomonitor %s eDP-1;" $i; done
    )"

    hyprctl dispatch movetoworkspace 5,class\:\(discord\)
    hyprctl dispatch movetoworkspace 4,class\:\(Slack\)

    eww open bar --screen 0
else
    touch /tmp/.home_layout.lock

    ln -sf ~/.config/hypr/monitors/home.conf ~/.config/hypr/monitors.conf
    ln -sf ~/.config/hypr/rules/home.conf ~/.config/hypr/rules.conf
    hyprctl reload

    hyprctl --batch "$(
        for i in {1..10}; do printf "dispatch moveworkspacetomonitor %s HDMI-A-1;" $i; done
    )"

    hyprctl dispatch movetoworkspace 9,class\:\(discord\)
    hyprctl dispatch movetoworkspace 10,class\:\(Slack\)

    eww open bar --screen 1
fi