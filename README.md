# Dotfiles

## Pre-requisites

```BASH
$ yay -S 
    stow git # to manage dotfiles
    zsh zoxide exa # shell things
    hyprland hyprpaper eww cliphist mako wofi # hyprland things
    playerctl wpctl # programs used in eww tab
    vesktop alacritty # other programs
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

### Dotfiles

```BASH
$ git clone git@github.com:patrick11514/dotfiles.git
$ cd dotfiles
$ stow --adopt .
```

### Same KDE settings (old)
```BASH
sudo pacman -S python-pipx # if you don't have already installed pipx
pipx install konsave # install konsave
pipx inject konsave setuptools # install setuptools in konsave venv
konsave -i konsave/KDE_settings.knsv # import profile
konsave -a KDE_settings # apply profile
```
