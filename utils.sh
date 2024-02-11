#!/usr/bin/env zsh

print_header() {
  echo "=== $1 ==="
}

print_footer() {
  echo "=== $1 ✅ ==="
  echo ""
}

safe_create_folder() {
  folder_path=$1
  if [[ ! -d $folder_path ]]; then
    mkdir -p $folder_path
    echo -e "- created $folder_path folder 🆕"
  else
    echo -e "- $folder_path folder already exists 🗂"
  fi
}

DATETIME_FORMAT="%Y-%m-%d_%H-%M-%S"

create_backup() {
  mkdir -p "$HOME/.mac-setup-backups/"
  if [ -f "$1" ]; then
    cp "$1" "$HOME/.mac-setup-backups/$(basename $1)_$(date +$DATETIME_FORMAT)"
  fi
}