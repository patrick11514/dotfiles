#!/bin/bash

if [ -f /tmp/.move_workspaces.lock ]; then
    rm /tmp/.move_workspaces.lock
    
    ln -sf ~/.config/hypr/rules/single.lua ~/.config/hypr/rules.lua
    ln -sf ~/.config/hypr/rules/single.conf ~/.config/hypr/rules.conf 2>/dev/null || true
    hyprctl reload
    
    hyprctl --batch "$(
        for i in {1..10}; do printf "dispatch hl.dsp.workspace.move({ workspace = %s, monitor = 'eDP-1' }); " $i; done
    )"
    
    hyprctl dispatch 'hl.dsp.window.move({ workspace = 5, window = "class:discord" })'
    hyprctl dispatch 'hl.dsp.window.move({ workspace = 4, window = "class:Slack" })'
else
    touch /tmp/.move_workspaces.lock
    
    ln -sf ~/.config/hypr/rules/dual.lua ~/.config/hypr/rules.lua
    ln -sf ~/.config/hypr/rules/dual.conf ~/.config/hypr/rules.conf 2>/dev/null || true
    hyprctl reload
    
    hyprctl --batch "$(
        for i in {1..8}; do printf "dispatch hl.dsp.workspace.move({ workspace = %s, monitor = 'HDMI-A-1' }); " $i; done
        for i in {9..10}; do printf "dispatch hl.dsp.workspace.move({ workspace = %s, monitor = 'eDP-1' }); " $i; done
    )"
    
    hyprctl dispatch 'hl.dsp.window.move({ workspace = 9, window = "class:discord" })'
    hyprctl dispatch 'hl.dsp.window.move({ workspace = 10, window = "class:Slack" })'
fi
