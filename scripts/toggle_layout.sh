#!/bin/bash

if [ -f /tmp/.home_layout.lock ]; then
    rm /tmp/.home_layout.lock
    
    ln -sf ~/.config/hypr/monitors/work.lua ~/.config/hypr/monitors.lua
    ln -sf ~/.config/hypr/rules/single.lua ~/.config/hypr/rules.lua
    ln -sf ~/.config/hypr/monitors/work.conf ~/.config/hypr/monitors.conf 2>/dev/null || true
    ln -sf ~/.config/hypr/rules/single.conf ~/.config/hypr/rules.conf 2>/dev/null || true
    
    hyprctl dispatch 'hl.dsp.dpms({ action = "on", monitor = "eDP-1" })'
    hyprctl reload
    
    hyprctl --batch "$(
        for i in {1..10}; do printf "dispatch hl.dsp.workspace.move({ workspace = %s, monitor = 'eDP-1' }); " $i; done
    )"
    
    hyprctl dispatch 'hl.dsp.window.move({ workspace = 5, window = "class:discord" })'
    hyprctl dispatch 'hl.dsp.window.move({ workspace = 4, window = "class:Slack" })'
else
    touch /tmp/.home_layout.lock
    
    ln -sf ~/.config/hypr/monitors/home.lua ~/.config/hypr/monitors.lua
    ln -sf ~/.config/hypr/rules/home.lua ~/.config/hypr/rules.lua
    ln -sf ~/.config/hypr/monitors/home.conf ~/.config/hypr/monitors.conf 2>/dev/null || true
    ln -sf ~/.config/hypr/rules/home.conf ~/.config/hypr/rules.conf 2>/dev/null || true
    
    hyprctl dispatch 'hl.dsp.dpms({ action = "off", monitor = "eDP-1" })'
    hyprctl reload
    
    hyprctl --batch "$(
        for i in {1..10}; do printf "dispatch hl.dsp.workspace.move({ workspace = %s, monitor = 'HDMI-A-1' }); " $i; done
    )"
    
    hyprctl dispatch 'hl.dsp.window.move({ workspace = 9, window = "class:discord" })'
    hyprctl dispatch 'hl.dsp.window.move({ workspace = 10, window = "class:Slack" })'
fi
