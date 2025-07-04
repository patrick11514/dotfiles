# Dotfiles

## Overview

The repository consists of several parts:

- Root folder (.config, .gnupg, .local, .\*, ...) contains the static files, which are same on all devices. And are directly symklinked to the home directory.
- `template` folder, which cotains two thigns:
  - \_generator - a tool which is used to generate the dotfiles
  - rest of files - these are template files, which are parsed by the generator, and final version is placed in the root folder.

The dotfiles are primarly designed for Arch Linux + Hyprland, so use them at your own risk.
Also the dotfiles are specific to my setup, so you will need to modify them to fit your needs, and I will not provide support for that.

## Pre-requisites

```BASH
$ yay -S
    stow git # to manage dotfiles
    zsh zoxide exa # shell things
    hyprland hyprpaper hyprlock eww cliphist mate-polkit hypridle xdg-portal-hyprland # hyprland things
    playerctl jq nodejs # programs used in eww tab
    discord kitty thunar wofi-emoji neovim ripgrep ulauncher file-roller # other programs
    slurp grim # screenshotting
    qt5ct qt6ct breeze5 # qt things
    adw-gtk-theme nwg-look dconf-editor # gtk things
    network-manager-applet # network manager
    kwalletmanager kwallet-pam kwalletcli # kwallet things
```

## Installation

### Oh-my-zsh + Powerlevel10k + zsh-autosuggestions

```BASH
# installation of oh-my-zsh
$ sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install powerlevel10k and zsh-autosuggestions
$ git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"
$ git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

### Dotfiles + Eww + Other configs

```BASH
$ git clone git@github.com:patrick11514/dotfiles.git
$ cd dotfiles
# First we need to build dotfiles generator
$ cd template/_generator
$ npm install
$ npm run build
# Then we generate our dotfiles
$ npm run start --platform=nb/pc # nb = notebook config, pc = desktop config
# Now we can build eww tool
$ cd ../../.config/eww/cli
$ npm install
$ npm run build
# Then we can install our dotfiles
$ cd ../../..
$ stow --adopt .
```
