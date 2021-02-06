#!/usr/bin/env zsh

# Exit on first error
set -e

setup_dotfiles() {
  local DOTFILES="${1:-HOME/.dotfiles}"

  # Exit if .dotfiles directory is missing
  [[ ! -d "$DOTFILES" ]] && echo "$DOTFILES does not exist." && exit 1

  # Symlinks
  ln -s $DOTFILES/git/gitconfig $HOME/.gitconfig
  ln -s $DOTFILES/git/gitignore $HOME/.gitignore
  ln -s $DOTFILES/zsh/zshenv $HOME/.zshenv
}

setup_dotfiles "$1"