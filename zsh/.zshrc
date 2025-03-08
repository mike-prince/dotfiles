#!/usr/bin/env zsh

# .zshrc is loaded for interactive shells. This is where you put settings that
# affect the behavior of your shell sessions.


#
# Resources
# http://zsh.sourceforge.net
# http://zsh.sourceforge.net/Doc/Release/Options.html#Description-of-Options
# https://wiki.archlinux.org/index.php/zsh
#

#
# Profile zsh load
# https://blog.askesis.pl/post/2017/04/how-to-debug-zsh-startup-time.html
#
#zmodload zsh/zprof

#
# Index
#

# Changing Directories
# Completion
# Expansion and Globbing
# History
# Initialisation
# Input/Output
# Job Control
# Prompting
# Scripts and Functions
# Shell Emulation
# Shell State
# Zle
# Aliases
# Load additional zsh files

#
# Changing Directories
#

setopt AUTO_CD           # Change to directory without typing cd
setopt AUTO_PUSHD        # Make cd push the old directory onto the directory stack.
setopt PUSHD_SILENT      # Do not print the directory stack after pushd or popd.
setopt PUSHD_IGNORE_DUPS # Don't push duplicates onto the directory stack.

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias d='dirs -v | head -10'
alias 1='cd ~1'
alias 2='cd ~2'
alias 3='cd ~3'
alias 4='cd ~4'
alias 5='cd ~5'
alias 6='cd ~6'
alias 7='cd ~7'
alias 8='cd ~8'
alias 9='cd ~9'

function -() {
  cd -
}

# Make directory and change into it
function mkcd() {
  mkdir -p $@ && cd ${@:$#}
}

#
# Completion
#

local ZCOMPDUMP_PATH=$HOME/.cache/zsh/zcompdump
mkdir -p $(dirname $ZCOMPDUMP_PATH)

autoload -Uz compinit

# Only check .zcompdump once per 20 hours
# if [[ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' "$DOTFILES/zsh/tmp/zcompdump") ]]; then
#   compinit
# else
#   compinit -C
# fi

compinit -d $ZCOMPDUMP_PATH

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

bindkey '^[[Z' reverse-menu-complete # SHIFT+TAB to cycle menu in reverse

#
# Expansion and Globbing
#

#
# History
#

HISTFILE=$HOME/.cache/zsh/zsh_history

setopt BANG_HIST            # Treat the character ‘!’ specially.
setopt EXTENDED_HISTORY     # Write timestamps and durations to the history file.
setopt HIST_FIND_NO_DUPS    # When searching history find no duplicates even if not contiguous.
setopt HIST_IGNORE_DUPS     # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_SPACE    # Do not write to history file if first character is a space.
setopt HIST_REDUCE_BLANKS   # Remove superfluous whitespace from history file.
setopt HIST_VERIFY          # Load history line into line editor instead of expanding.
setopt INC_APPEND_HISTORY   # Write to history file immediately instead of upon shell exit.
setopt SHARE_HISTORY        # Share history between all sessions.

# Ignore common commands
HISTORY_IGNORE="(ls|cd|pwd|exit|cd ..)"

# Set history size
HISTSIZE=2000
SAVEHIST=1000

# # Enable history substring search
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

#
# Initialisation
#

#
# Input/Output
#

# setopt CORRECT_ALL          # Try to correct the spelling of all arguments.
setopt INTERACTIVE_COMMENTS # Allow comments even in interactive shel

#
# Job Control
#

setopt NO_CHECK_JOBS # Do not report the status of background jobs when the shell exits.
setopt NO_HUP        # Do not send HUP to running jobs when the shell exits.

#
# Prompting
#

# setopt PROMPT_SUBST # Expansions are performed in prompts.

# Load version control info
autoload -Uz vcs_info

precmd() {
  vcs_info
  psvar=()
  [[ -n $vcs_info_msg_0_ ]] && psvar[1]="$vcs_info_msg_0_ "
  [[ -n $(prompt_git_dirty) ]] && psvar[2]="* "
  [[ -n $(prompt_git_check ahead) ]] && psvar[3]="$(prompt_git_check ahead) "
  [[ -n $(prompt_git_check behind) ]] && psvar[4]="$(prompt_git_check behind) "
}

zstyle ':vcs_info:*' enable git   # Enable git support
zstyle ':vcs_info:*' formats '%b' # Format the vcs_info_msg_0_ variable

prompt_git_dirty() {
  git rev-parse --is-inside-work-tree &> /dev/null || return
  if [ -n "$(git status --porcelain)" ]; then
    echo "*"
  fi
}

prompt_git_check() {
  # Ensure we're inside a Git repository and the branch has an upstream
  git rev-parse --is-inside-work-tree &> /dev/null || return
  git rev-parse --abbrev-ref @{upstream} &> /dev/null || return

  local ahead behind

  case "$1" in
    ahead )
      ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null)
      (( ahead > 0 )) && echo "⇡${ahead}" ;;
    behind )
      behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null)
      (( behind > 0 )) && echo "⇣${behind}" ;;
  esac
}

prompt_git_check() {
  # Check if we're in a git repository and if upstream exists
  git rev-parse --is-inside-work-tree &> /dev/null || return
  git rev-parse --abbrev-ref @{upstream} &> /dev/null || return

  local counts=$(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)
  local ahead=$(echo $counts | awk '{print $2}')
  local behind=$(echo $counts | awk '{print $1}')

  case "$1" in
    ahead  ) (( ahead > 0 )) && echo "⇡${ahead}" ;;
    behind ) (( behind > 0 )) && echo "⇣${behind}" ;;
  esac
}

PROMPT=''                # Clear prompt
PROMPT+='%1~ '           # Add pwd
PROMPT+='%F{blue}%1v'    # Add git branch
PROMPT+='%F{red}%2v'     # Add git dirty
PROMPT+='%F{green}%3v'   # Add git ahead
PROMPT+='%F{red}%4v'     # Add git behind
PROMPT+='%F{yellow}❯%f ' # Add prompt character

# precmd() { vcs_info }
# precmd_functions+=( precmd_vcs_info )

# setopt PROMPT_SUBST

# PROMPT='%1~ %F{green}${vcs_info_msg_0_}%f%# '

# source <(fzf --zsh)

# zstyle ':vcs_info:git:*' formats '%b '

#
# Scripts and Functions
#

setopt MULTIOS # Perform implicit tees/cats when multiple redirections are attempted.

#
# Shell Emulation
#

#
# Shell State
#

#
# Zle
#

setopt NO_BEEP         # Do no beep on error in ZLE.
setopt COMBINING_CHARS # Combine zero-length punctuation characters.

#
# Aliases
#

# Restart zsh session (not just source config)
alias zsh_restart='exec zsh'

# Listing
l() {
    local CONTENT=$(ls -GH1)
    if [ -z ${CONTENT} ]; then
      printf "\n\033[0;37mEMPTY\n\n"
    else
      echo ''; ls -GH1; echo ''
    fi
}

# alias l='echo ''; ls -GH1; echo '''
alias la='ls -GHa'
alias ll='ls -GHlh'
alias lla='ls -GHlah'
alias ls='ls -GHF'
alias sl='ls'

# Dotfiles shortcut
alias dots="code ${DOTFILES}"

# Tree helpers
alias tree='tree --dirsfirst --noreport --gitignore -C'
alias treed='t -d' # Directories only

t1() { tree -L 1 "${1:-.}"; echo; }
t2() { tree -L 2 "${1:-.}"; echo; }
t3() { tree -L 3 "${1:-.}"; echo; }
t4() { tree -L 4 "${1:-.}"; echo; }
t5() { tree -L 5 "${1:-.}"; echo; }

# Print each PATH entry on a separate line
alias lspath="echo ${PATH//:/\\\n}"

alias hub="github ."

#
# Functions
#

t() {
  local dir="${1:-.}" # Accepts a directory argument or defaults to current directory
  local LINE_COUNT=$(tree -L 2 -i "$dir" | wc -l | tr -d '[:space:]')

  if [ $LINE_COUNT -gt 20 ]; then
    t1 "$dir"
  else
    t2 "$dir"
  fi
}

# Directories
cd() {
    builtin cd "$@" || return
    printf "\n\033[0;33m${PWD}\n"
    t
}

# Zsh launch timer
zsh_timer() {
  local count="$1"
  if (( $# != 1 )); then
    count=10
  fi
  for i in $(seq 1 "$count"); do /usr/bin/time /bin/zsh -i -c exit; done;
}

# Zsh profiling
zsh_profile() {
  # Enable profiling in zshrc
  sed -i '' -e 's/^#zmodload/zmodload/' "$DOTFILES/zsh/.zshrc"
  sed -i '' -e 's/^#zprof/zprof/' "$DOTFILES/zsh/.zshrc"

  # Profile zsh
  /bin/zsh -i -c exit

  # Disable profiling in zshrc
  sed -i '' -e 's/^zmodload/#zmodload/' "$DOTFILES/zsh/.zshrc"
  sed -i '' -e 's/^zprof/#zprof/' "$DOTFILES/zsh/.zshrc"
}

#
# Load additional zsh files
#

for zshfile ($DOTFILES/zsh/addons/*.zsh); do
  source "${zshfile}"
done

#
# Additional Settings
#

if command -v fzf &> /dev/null; then
  source <(fzf --zsh --extended)
fi

source /opt/homebrew/share/zsh/site-functions/aws_zsh_completer.sh

#
# End profiling zsh load
#
#zprof

#
# New session commands
#

if [[ $PWD == $HOME ]]; then
  pushd ~/ShakeIQ/Github
  pushd ~/ShakeIQ
  pushd ~/Code/dotfiles
  pushd ~/Code
  d | grep -v 0 | sed 's/~\///'
  printf "\n\033[33m%s\033[0m\n\n" ${PWD}
fi

#
# Private 
#

[[ -f $DOTFILES/private ]] && source "$DOTFILES/private"
