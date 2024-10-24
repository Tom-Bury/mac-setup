#!/usr/bin/env zsh

SCRIPT_DIR="$(dirname "$0")"

rm -rf "$HOME/zshrc-scripts"

source "$SCRIPT_DIR/install-packages.sh"
install_packages

zsh "$SCRIPT_DIR/../shared/main.sh"

SCRIPT_DIR="$(dirname "$0")"

zsh "$SCRIPT_DIR/../setup-vscode-extensions.sh"
