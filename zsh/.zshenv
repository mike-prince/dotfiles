#!/usr/bin/env zsh

# .zshenv is executed for all instances of zsh, including scripts. Include
# anything that should be available to all zsh instances, including scripts.

# unsetopt GLOBAL_RCS # Do not read global configs

# Dotfiles
export DOTFILES=$(dirname $(dirname $(readlink -f ~/.zshenv)))
export ZDOTDIR=$DOTFILES/zsh

# Cache file location
export LESSHISTFILE=-
export ZSH_SESSION=$HOME/.cache/zsh
