# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
if test -z "$XDG_RUNTME_DIR"; then
	export XDG_RUNTIME_DIR="/run/user/$(id -u)"
	mkdir -p "$XDG_RUNTIME_DIR"
	chmod 0700 "$XDG_RUNTIME_DIR"
fi

ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

export ZSH="$HOME/.oh-my-zsh"
# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

plugins=(
	git
	zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  wd
  sudo
)

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit
source "$ZSH/oh-my-zsh.sh"

source <(fzf --zsh)

# User configuration
export EDITOR="bob run nightly"

export MUSIC="$HOME/music"

# setup govm
export PATH="$HOME/.govm/shim:$PATH"

# setup custom script PATH
export PATH="$PATH:$HOME/script"

# setup wallpaper
export WALLPAPER=~/pict/memship_wp/*June*without*

wal -i $WALLPAPER

# setup keyring
export $(gnome-keyring-daemon --start --components=secrets 2>/dev/null)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

#Startx Automatically
if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then
	startx
	logout
fi

# source all user defined config
source ~/.zscript/.zalias
source ~/.zscript/.zkey
source ~/.zscript/.zfunc

#exec init func
restart_wall
clear
ff
