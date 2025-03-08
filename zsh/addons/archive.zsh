#!/usr/bin/env zsh

#
# Functions to create, list and extract archives
#

# Exclude mac specific files from archives
alias 7z="7z -x \*.DS_Store -x \*__MACOSX\* -x \*.AppleDouble\*"
alias tar="tar --exclude \*.DS_Store --exclude \*__MACOSX\* --exclude \*.AppleDouble\*"
alias zip="zip -x \*.DS_Store -x \*__MACOSX\* -x \*.AppleDouble\*"

#
# Create archive
#

archive() {
  if (( $# != 2 )); then
cat <<- 'EOF'
usage: archive [archive_name.zip] [/path/to/archive]

Where 'archive_name.zip' uses any of the following extensions:
  .7z, .tar, .tar.bz2, .tar.gz, .tar.xz, .zip

info:
  Archive only                        tar
  Compression only                    bz2, gz, xz
  Compression + Archive               7z, zip

  Compression speed (fast > slow)     gz < zip < bz2 < xz < 7z
  Compression ratio (better > worse)  xz > 7z > bz2 > gz > zip
EOF
    return 1
  fi

  local archive_name="${1:t}"

  case "${archive_name}" in
    (*.7z) 7z a "${archive_name}" "$2" ;;
    (*.tar) tar -cvf "${archive_name}" "$2" ;;
    (*.tar.bz2|*.tbz|*.tbz2) tar -jcvf "${archive_name}" "$2" ;;
    (*.tar.gz|*.tgz) tar -zcvf "${archive_name}" "$2" ;;
    (*.tar.xz|*.txz) tar -Jcvf "${archive_name}" "$2" ;;
    (*.zip) zip -r "${archive_name}" "$2" ;;
    (*) print "\nUnknown archive type for: $2" ;;
  esac
}

#
# List archive
#

lsarchive() {
  if (( $# != 1 )); then
cat >&2 <<- 'EOF'
usage: lsarchive [archive_name.zip]

info:
  Supports .7z, .tar, .tar.bz2, .tar.gz, .tar.xz, .zip
EOF
    return 1
  fi

  local archive_name="${1:t}"

  case "${archive_name}" in
    (*.7z) 7za l "$1" ;;
    (*.tar) tar tf "$1" ;;
    (*.tar.bz2|*.tbz|*.tbz2) tar tjf "$1" ;;
    (*.tar.gz|*.tgz) tar tvzf "$1" ;;
    (*.tar.xz|*.txz) tar --xz -tf "$1" ;;
    (*.zip) unzip -l "$1" ;;
    (*) print "\nCannot list: $1" ;;
  esac
}

#
# Extract archive
#

unarchive() {
  if (( $# != 1 )); then
cat >&2 <<- 'EOF'
usage: unarchive [archive_name.zip]

info:
  Supports .7z, .tar, .tar.bz2, .tar.gz, .tar.xz, .zip
EOF
  return 1
  fi

  case "$1" in
    (*.7z) 7za x "$1" ;;
    (*.tar) tar -xvf "$1" ;;
    (*.tar.bz2|*.tbz|*.tbz2) tar -jxvf "$1" ;;
    (*.tar.gz|*.tgz) tar -zxvf "$1" ;;
    (*.tar.xz|*.txz) tar -Jxvf "$1" ;;
    (*.zip) unzip "$1" ;;
    (*) print "\nunknown archive type for: $1" ;;
  esac
}
