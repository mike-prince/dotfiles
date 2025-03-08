#!/usr/bin/env zsh

# Exit on first error
set -e

setup_dotfiles() {
  DOTFILES=${1:-$HOME/.dotfiles}

  echo $DOTFILES

  # Exit if dotfiles directory is missing
  [[ ! -d "$DOTFILES" ]] && echo "$DOTFILES does not exist." && exit 1

  mkdir -p $HOME/.cache/zsh

  # Backup existing files
  cp $HOME/.gitconfig $HOME/.gitconfig.bak 2>/dev/null
  cp $HOME/.gitignore $HOME/.gitignore.bak 2>/dev/null
  cp $HOME/.zshenv $HOME/.zshenv.bak 2>/dev/null

  # Symlinks
  ln -s $DOTFILES/git/gitconfig $HOME/.gitconfig
  ln -s $DOTFILES/git/gitignore $HOME/.gitignore
  ln -s $DOTFILES/zsh/.zshenv $HOME/.zshenv
}

setup_dotfiles $1
