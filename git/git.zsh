#!/usr/bin/env zsh

alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gc='git commit'
alias gcb='git checkout -b'
alias gs='git status'

# List github repos for the given user
repos() {
  local user="$1"
  local uri="https://api.github.com/users/$user/repos"
  printf "github.com/${user}:\n"
  curl -s  $uri | grep '"name":' | grep -v MIT | sed 's/[ ",]//g' | sed 's/name:/ /'
  printf "\n"
}

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