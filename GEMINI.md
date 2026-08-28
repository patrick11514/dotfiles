# Dotfiles Project Architecture & Guidelines

This document provides context on the repository structure, template generator engine, script utilities, and workflows.

---

## 1. Repository Structure & Purpose

```
.
├── .config/             # Generated & static application configs (Hyprland, Waybar, Kitty, Neovim, etc.)
├── .gnupg/              # GnuPG configuration
├── .local/              # Local desktop entries and binaries
├── .p10k.zsh            # Powerlevel10k Zsh theme configuration
├── .zshrc               # Generated user Zsh configuration
├── scripts/             # Utility scripts used across desktop/laptop workflows
├── template/            # Source templates with conditional logic for multi-platform setups
│   ├── .config/         # Templated configurations (Hyprland, Waybar, Pipewire, LazyGit, etc.)
│   ├── .zshrc           # Templated Zsh configuration
│   └── _generator/      # Node.js / TypeScript template compiler application
├── .gemini/             # Antigravity / Gemini assistant configurations & workspace skills
└── README.md            # Installation & setup instructions
```

- **`./` (Root Directory)**: Acts as the GNU Stow package directory. When deployed with `stow --adopt .`, root-level files and directories are symlinked directly into the user's home directory (`$HOME` / `~`).
- **`scripts/`**: Useful shell scripts for system administration, Waybar modules, Hyprland window/workspace routing, power profile toggling, monitor switching, and application shortcuts.
- **`template/`**: Contains raw config templates. Files here should be edited when modifying configurations that vary across machines.
- **`template/_generator/`**: The compilation engine that reads `template/` files, resolves conditional blocks according to the target platform, and emits the final configurations into the repository root (`./`).

---

## 2. Template Generator (`template/_generator`)

The generator is a TypeScript/Node.js CLI tool located in `template/_generator`.

### Supported Platforms
- `pc`: Desktop workstation configuration (e.g., dedicated GPU, multi-monitor / DP-1 outputs, specific completions, LM Studio path).
- `nb`: Laptop / Notebook configuration (e.g., battery module, backlight control, dynamic power profile management).

### Platform State & Execution
- Platform state is saved in `template/_generator/platform.txt`.
- **Build**:
  ```bash
  cd template/_generator
  npm install
  npm run build
  ```
- **Generate**:
  ```bash
  # Using CLI arg
  npm run start -- --platform=pc   # or --platform=nb
  
  # Or via helper script (uses existing platform.txt)
  ./buildDotfiles
  ```

### Template Syntax & Variables
The parser processes template files line-by-line supporting JavaScript conditional expressions:

- `{{ if <condition> }}`
- `{{ else if <condition> }}`
- `{{ else }}`
- `{{ end }}`

#### Available Variables
- `platform`: String (`"pc"` or `"nb"`)

#### Example Template Usage (`template/.config/waybar/config.jsonc`)
```jsonc
{
{{ if platform == "pc" }}
    "output": "DP-1",
{{ end }}
    "modules-right": [
        "cpu",
        "memory",
        "pulseaudio",
{{ if platform == "nb" }}
        "backlight",
        "custom/power_profile",
        "battery",
{{ end }}
        "tray",
        "clock"
    ]
}
```

### File Handling & Symlink Rules
- **Directory mirroring**: Subdirectories under `template/` are mirrored to `./`.
- **Ignored paths**: `_generator`, `node_modules`, `.git`.
- **Symlinks**: Target symlinks such as `monitors.lua` / `rules.lua` (and legacy `.conf`) are copied/preserved to target destinations.
- **File Modes**: Original file permission modes are preserved upon generation.

---

## 3. Scripts Directory (`scripts/`)

Key utilities include:
- `power_profile.sh` / `power_profile_pc.sh` / `power_profile_nb.sh` / `setup_power_sudo.sh`: Power profile manager (CPU EPP for desktop PC, ACPI platform profiles for notebook) with JSON output for Waybar and passwordless sudo support.
- `toggle_layout.sh` / `toggle_monitor.sh` / `restoreMonitors.sh` / `movie_monitors.sh`: Hyprland multi-monitor layout switchers (work vs. home setups) and workspace reassignment.
- `brightness.sh`: Laptop screen brightness adjustment with notification feedback.
- `startZed.sh` / `gitArchive.sh` / `upload.sh`: Development shortcuts and helpers.

---

## 4. Deployment Workflow

1. Modify configuration templates in `template/` or scripts in `scripts/`.
2. Re-run generator:
   ```bash
   cd template/_generator && npm run start
   ```
3. Update symlinks via GNU Stow:
   ```bash
   cd /home/patrick115/dotfiles && stow --adopt .
   ```
