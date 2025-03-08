#!/usr/bin/env zsh

alias g='git'

# Download the latest commit from the given repo
clonelatest() {
  if (( $# < 2 )); then
cat <<- 'EOF'
usage: clonelatest [git repo url] [destination path](optional)

example:
  clonelatest github.com/mike-prince/word-gen
EOF
    return 1
  fi

  local repo_url
  git clone --depth 1 https://"$1".git $2

  # Delete .git/ from the cloned repo
  if [ -z $2 ]; then
    rm -rf ${repo_url##*/}/.git
  else
    rm -rf $2/.git
  fi
}
