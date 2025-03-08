#!/usr/bin/env zsh

# .zprofile file is executed for login shells. This is where you put settings
# that will only be applied once per login. For example, anything set here
# such as paths will not be available to scripts.

#
# Environment Variables
#

export EDITOR='vim'

# Setup Homebrew if it's installed
if ! [[ -x "$(command -v brew)" ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

XDG_CONFIG_HOME=$HOME/.config/

#
# Paths
#

# Set GOPATH if Go is installed
if [[ -x "$(command -v go)" ]]; then
	export GOPATH=$HOME/go
	PATH=$PATH:$GOPATH:$HOME/.node/bin
fi

# Update path if n is installed
if [[ -x "$(command -v n)" ]]; then
	PATH=$PATH:$HOME/.node/bin
fi

# Update path for python
PATH=$PATH:$HOME/Library/Python/3.9/bin

# Eliminate duplicates in paths
typeset -gU cdpath fpath path

export N_PREFIX=~/.node
