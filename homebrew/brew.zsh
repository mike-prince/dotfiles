#!/usr/bin/env zsh

brewfile="$DOTFILES/homebrew/Brewfile"

# Ensure a Brewfile exists
if [ ! -f $DOTFILES/homebrew/Brewfile ]; then
  touch $DOTFILES/homebrew/Brewfile
fi

# Function to make brew bundle always use the specified Brewfile
function brew() {
  # Check if sub-command is bundle
  if [[ "$1" = "bundle" ]]; then
  /usr/local/bin/brew "$@" --file="$brewfile" --force --describe
  else
  /usr/local/bin/brew "$@"
  fi
}

# Function to list all formulae with descriptions and casks
function brewlist() {
  printf 'Collecting leaves....\n'
  printf '\nFormula:\n'
  brew leaves | xargs -n1 brew desc | sed 's/^/ /' | sed 's/:/##/' | column -ts '##'
  printf '\nCasks:\n'
  for i in $(brew list -1 --cask); do
    printf "$i\n" | sed 's/^/ /'
  done
}

# Update bundle in background if Brewfile is older than 7 days
if [[ $(find "$brewfile" -mtime +7) ]]; then
  ( brew bundle dump &>/dev/null & )
fi