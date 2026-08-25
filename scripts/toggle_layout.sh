#!/bin/bash

if [ -f /tmp/.home_layout.lock ]; then
    rm /tmp/.home_layout.lock
    
    ln -sf ~/.config/hypr/monitors/work.lua ~/.config/hypr/monitors.lua
    ln -sf ~/.config/hypr/rules/single.lua ~/.config/hypr/rules.lua
    ln -sf ~/.config/hypr/monitors/work.conf ~/.config/hypr/monitors.conf 2>/dev/null || true
    ln -sf ~/.config/hypr/rules/single.conf ~/.config/hypr/rules.conf 2>/dev/null || true
    
    hyprctl dispatch dpms on eDP-1
    hyprctl reload
    
    hyprctl --batch "$(
        for i in {1..10}; do printf "dispatch moveworkspacetomonitor %s eDP-1;" $i; done
    )"
    
    hyprctl dispatch movetoworkspace 5,class\:\(discord\)
    hyprctl dispatch movetoworkspace 4,class\:\(Slack\)
else
    touch /tmp/.home_layout.lock
    
    ln -sf ~/.config/hypr/monitors/home.lua ~/.config/hypr/monitors.lua
    ln -sf ~/.config/hypr/rules/home.lua ~/.config/hypr/rules.lua
    ln -sf ~/.config/hypr/monitors/home.conf ~/.config/hypr/monitors.conf 2>/dev/null || true
    ln -sf ~/.config/hypr/rules/home.conf ~/.config/hypr/rules.conf 2>/dev/null || true
    
    hyprctl dispatch dpms off eDP-1
    hyprctl reload
    
    hyprctl --batch "$(
        for i in {1..10}; do printf "dispatch moveworkspacetomonitor %s HDMI-A-1;" $i; done
    )"
    
    hyprctl dispatch movetoworkspace 9,class\:\(discord\)
    hyprctl dispatch movetoworkspace 10,class\:\(Slack\)
fi
