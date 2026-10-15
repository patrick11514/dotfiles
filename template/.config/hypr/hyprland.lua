-- #######################################################################################
-- HYPRLAND LUA CONFIGURATION
-- #######################################################################################

----------------
--- MONITORS ---
----------------

{{ if platform == "pc" }}
local monitor_left = "HDMI-A-1"
local monitor_center = "DP-1"
local monitor_right = "HDMI-A-2"

hl.monitor({ output = monitor_left, mode = "1920x1080@60", position = "0x180", scale = 1 })
hl.monitor({ output = monitor_center, mode = "2560x1440@240", position = "1920x0", scale = 1 })
hl.monitor({ output = monitor_right, mode = "1920x1080@60", position = "4480x180", scale = 1 })
{{ else }}
require("monitors")
{{ end }}

-------------------
--- MY PROGRAMS ---
-------------------

local terminal = "kitty"
local fileManager = "thunar"
local menu = "wofi -a --show drun --allow-images --insensitive"

-----------------
--- AUTOSTART ---
-----------------

hl.on("hyprland.start", function()
    -- notification manager
    hl.exec_cmd("mako --default-timeout 5000")
    -- status bar
    hl.exec_cmd("waybar")
    -- discord
    hl.exec_cmd("discord --enable-blink-features=MiddleClickAutoscroll --disable-features=WebRtcAllowInputVolumeAdjustment")
    -- wallpaper
    hl.exec_cmd("hyprpaper")
    -- clipboard
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    -- clear clipboard history after every login
    hl.exec_cmd("cliphist wipe")
    -- wifi
    hl.exec_cmd("nm-applet --indicator")
    -- disable rgb
    hl.exec_cmd("openrgb --startminimized --profile DEFAULT")
    -- polkit
    hl.exec_cmd("/usr/lib/mate-polkit/polkit-mate-authentication-agent-1")
    -- playerctl daemon
    hl.exec_cmd("playerctld daemon")
{{ if platform == "pc" }}
    -- steam
    hl.exec_cmd("/usr/bin/steam -silent")
{{ end }}
    -- ulauncher
    hl.exec_cmd("ulauncher --hide-window")
    -- hypridle
    hl.exec_cmd("hypridle")
{{ if platform == "pc" }}
    -- streamdeck
    hl.exec_cmd("streamcontroller -b")
{{ else }}
    -- bluetooth applet
    hl.exec_cmd("blueman-applet")
{{ end }}
    -- initial lock
    hl.exec_cmd("hyprlock")
    -- kwallet
    hl.exec_cmd("/usr/bin/kwalletd6")
end)

-----------------------------
--- ENVIRONMENT VARIABLES ---
-----------------------------

hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "breeze_cursors")

---------------------
--- LOOK AND FEEL ---
---------------------

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 20,
        border_size = 2,
        ["col.active_border"] = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
        ["col.inactive_border"] = "rgba(595959aa)",
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
    dwindle = {
        preserve_split = true,
        force_split = 2,
    },
    master = {
        new_status = "master",
    },
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
        middle_click_paste = false,
        anr_missed_pings = 10,
{{ if platform == "pc" }}
        vrr = 2,
{{ end }}
    },
    input = {
        kb_layout = "cz",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
            disable_while_typing = false
        },
        accel_profile = "flat",
        numlock_by_default = true,
{{ if platform == "pc" }}
        tablet = {
            output = monitor_center,
            relative_input = false,
        },
{{ else }}
        tablet = {
            output = "current",
            relative_input = false,
        },
{{ end }}
    },
    cursor = {
        no_hardware_cursors = 1,
    },
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

------------------
--- ANIMATIONS ---
------------------

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

-------------------
--- KEYBINDINGS ---
-------------------

local mainMod = "SUPER"

-- Example binds
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("ulauncher-toggle"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Czech layout keys for workspaces 1-10
local ws_keys = {
    [1] = "plus",
    [2] = "ecaron",
    [3] = "scaron",
    [4] = "ccaron",
    [5] = "rcaron",
    [6] = "zcaron",
    [7] = "yacute",
    [8] = "aacute",
    [9] = "iacute",
    [10] = "eacute",
}

for i, key in ipairs(ws_keys) do
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media keys
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl --player=spotify,%any play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl --player=spotify,%any previous"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl --player=spotify,%any next"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
{{ if platform == "nb" }}
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/scripts/brightness.sh down"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/scripts/brightness.sh up"))
{{ end }}

-- Clipboard history
hl.bind("ALT + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp -o)" - | wl-copy'))
hl.bind("CTRL + Print", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd('grim -g "$(slurp -o)" - > /tmp/screenshot.png && ~/scripts/upload.sh'))
hl.bind("CTRL + SHIFT + Print", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - > /tmp/screenshot.png && ~/scripts/upload.sh'))
hl.bind("ALT + Print", hl.dsp.exec_cmd("grim - | wl-copy"))
hl.bind("ALT + SHIFT + Print", hl.dsp.exec_cmd("grim - > /tmp/screenshot.png && ~/scripts/upload.sh"))

-- Lockscreen
hl.bind(mainMod .. " + l", hl.dsp.exec_cmd("hyprlock"))
hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("hyprlock"), { locked = true })

-- Gromit MPX
hl.bind(mainMod .. " + G", hl.dsp.workspace.toggle_special("gromit"))

-- Emoji select
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("wofi-emoji"))

-- Fullscreen
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

{{ if platform == "nb" }}
hl.bind(mainMod .. " + minus", hl.dsp.exec_cmd("~/scripts/move_workspaces.sh"))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd("~/scripts/toggle_layout.sh"))
{{ end }}

------------------------------
--- WINDOWS AND WORKSPACES ---
------------------------------

{{ if platform == "pc" }}
hl.workspace_rule({ workspace = "1", monitor = monitor_center, default = true })
hl.workspace_rule({ workspace = "2", monitor = monitor_center })
hl.workspace_rule({ workspace = "3", monitor = monitor_center })
hl.workspace_rule({ workspace = "4", monitor = monitor_center })
hl.workspace_rule({ workspace = "5", monitor = monitor_center })
hl.workspace_rule({ workspace = "6", monitor = monitor_center })
hl.workspace_rule({ workspace = "7", monitor = monitor_left, default = true })
hl.workspace_rule({ workspace = "8", monitor = monitor_left })
hl.workspace_rule({ workspace = "9", monitor = monitor_right, default = true })
hl.workspace_rule({ workspace = "10", monitor = monitor_right })
{{ else }}
for i = 1, 10 do
    if i == 1 then
        hl.workspace_rule({ workspace = tostring(i), persistent = true, default = true })
    else
        hl.workspace_rule({ workspace = tostring(i), persistent = true })
    end
end
{{ end }}

hl.workspace_rule({ workspace = "special:gromit", gaps_in = 0, gaps_out = 0, on_created_empty = "gromit-mpx -a" })

-- Move programs to correct workspace
{{ if platform == "pc" }}
hl.window_rule({ match = { class = "vesktop" }, workspace = "9 silent" })
hl.window_rule({ match = { class = "discord" }, workspace = "9 silent" })
{{ else }}
require("rules")
{{ end }}
hl.window_rule({ match = { class = "^(TeamSpeak)$" }, workspace = "7 silent" })
hl.window_rule({ match = { class = "Spotify" }, workspace = "6 silent" })
{{ if platform == "pc" }}
-- obs
hl.window_rule({ match = { class = "com.obsproject.Studio" }, workspace = "8" })
-- chromium browsers
hl.window_rule({ match = { class = "Chromium" }, workspace = "8 silent", tile = true })
-- dev
hl.window_rule({ match = { class = "twitchchat" }, workspace = "10 silent" })

-- Gromit MPX
hl.window_rule({
    match = { class = "^(Gromit-mpx)$" },
    no_blur = true,
    opacity = "1",
    no_shadow = true,
    fullscreen = true,
    size = { "100%", "100%" },
})
{{ end }}

-- ulauncher
hl.window_rule({
    match = { class = "ulauncher" },
    no_blur = true,
    no_shadow = true,
    border_size = 0,
})

{{ if platform == "pc" }}
hl.window_rule({ match = { class = "org.stellarium.stellarium" }, monitor = monitor_center })
{{ end }}

hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
