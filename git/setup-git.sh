#!/usr/bin/env zsh

SCRIPT_DIR="$(dirname "$0")"

GIT_CONFIG="$HOME/.gitconfig"

setup_git() {
  create_backup $GIT_CONFIG
  cp "$SCRIPT_DIR/.gitconfig" $GIT_CONFIG
}
