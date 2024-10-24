#!/usr/bin/env zsh

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/../utils.sh"

zsh "$SCRIPT_DIR/../setup-preferences.sh"

sudo -v # Ask for the administrator password upfront

print_header "Setting up Git 🐙"
source "$SCRIPT_DIR/git/setup-git.sh"
setup_git
print_footer "Git set up"

print_header "Creating folders 📂"
safe_create_folder $HOME/personal/code
safe_create_folder $HOME/work/code
print_footer "Folders created"

SCRIPT_DIR="$(dirname "$0")"

print_header "Setting up ZSH shell 🐚"
source "$SCRIPT_DIR/zsh/setup-shell.sh"
setup_shell
print_footer "Shell set up"

SCRIPT_DIR="$(dirname "$0")"

if [ "$NODE" = true ]; then
  print_header "Setting up Node.js 🟢"
  source "$SCRIPT_DIR/node/setup-nvm.sh"
  setup_nvm
  print_footer "Node.js with NVM set up"
fi

SCRIPT_DIR="$(dirname "$0")"

if [ "$PYTHON" = true ]; then
  print_header "Setting up Python 🐍"
  source "$SCRIPT_DIR/python/setup-python.sh"
  setup_python
  print_footer "Python set up"
fi