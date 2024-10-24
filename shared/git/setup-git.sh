#!/usr/bin/env zsh

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/../../utils.sh"

GIT_CONFIG="$HOME/.gitconfig"

setup_git() {
  create_backup $GIT_CONFIG
  cp "$SCRIPT_DIR/.gitconfig" $GIT_CONFIG
  setup_extra_source_scripts "$SCRIPT_DIR"
}
