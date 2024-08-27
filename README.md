# Dotfiles

## Pre-requisites

```BASH
$ yay -S
    stow git # to manage dotfiles
    zsh zoxide exa # shell things
    hyprland hyprpaper hyprlock eww cliphist mako wofi # hyprland things
    playerctl jq # programs used in eww tab
    vesktop alacritty lf # other programs
    slurp grim # screenshotting
    qt5ct qt6ct breeze5 # 
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

### Configuration

#### Hyprland

-   Configure correct displays in .config/hypr/hyprland.conf ($monitor-left, $monitor-right and $monitor-center), or comment these variables. These wariables are used in config file to set workspaces etc...
-   Hyprpaper at: .config/hypr/hyprpaper.conf also configure correct displays + parth to your background image

### EWW

-   First you need to build cli tool

```BASH
$ cd .config/eww/cli
# for npm users
$ npm install
$ npm run build

# for pnpm users
$ pnpm install
$ pnpm build
```

-   Then configure number of workspaces and correct displays
-   Configuration is at: .config/eww/eww.yuck
    -   Change variables: workspaces and workspace_list, where param for genArray set tu number of your workspaces
    -   Change displays replace every :monitor 1 with your monitor number