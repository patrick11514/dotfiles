# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#lang
export LANG=cs_CZ.UTF-8
export LC_ALL=cs_CZ.UTF-8

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#aliases
alias ls='exa --group-directories-first --icons'
alias ll='exa -la --group-directories-first --icons'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

PATH="$PATH:/home/patrick115/scripts:$HOME/.local/bin:$HOME/Programs/adb"

# pnpm
export PNPM_HOME="/home/patrick115/.local/share/pnpm"
case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export GPG_TTY=$TTY
alias neofetch="fastfetch --kitty ~/dotfiles/fetch.png --logo-width 50"

PATH=~/.console-ninja/.bin:$PATH
. "$HOME/.cargo/env"

[ -f ~/.inshellisense/key-bindings.zsh ] && source ~/.inshellisense/key-bindings.zsh

eval "$(zoxide init zsh --cmd cd)"

alias c="~/scripts/startZed.sh"
alias gitArchive="~/scripts/gitArchive.sh"
alias ta-vec-na-klavesy="wev"
alias lsblk="lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,MOUNTPOINTS,UUID"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

export PATH="$PATH:/home/patrick115/dotfiles/template/_generator"

{{ if platform == "pc" }}
# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/patrick115/.lmstudio/bin"

# bun completions
[ -s "/home/patrick115/.bun/_bun" ] && source "/home/patrick115/.bun/_bun"
{{ end }}
