#!/usr/bin/env zsh

# Inspiration - General script
#
# - https://gist.github.com/codeinthehole/26b37efa67041e1307db
# - https://www.lotharschulz.info/2021/05/11/macos-setup-automation-with-homebrew/

ROOT_DIR="$(dirname "$0")"
source "$ROOT_DIR/utils.sh"

sudo -v # Ask for the administrator password upfront

print_header "Setting up Git 🐙"
source "$ROOT_DIR/git/setup-git.sh"
setup_git
print_footer "Git set up"

print_header "Setting up OSX preferences 🖥"
source "$ROOT_DIR/osx/setup-osx.sh"
require_password_on_sleep
setup_typing_preferences
setup_finder
enable_snap_to_grid
expand_save_and_print_dialogs
setup_dock
setup_mission_control
setup_simulators

killall Finder
killall Dock
print_footer "OSX preferences set up"


print_header "Installing HomeBrew 🍺"
source "$ROOT_DIR/homebrew/setup-homebrew.sh"
install_homebrew
print_footer "HomeBrew installed"

print_header "Downloading HomeBrew apps 📱"
download_homebrew_apps
print_footer "HomeBrew apps downloaded"


print_header "Setting up shell 🐚"
source "$ROOT_DIR/shell/setup-shell.sh"
setup_shell
print_footer "Shell set up"


print_header "Setting up NVM 📦"
source "$ROOT_DIR/nvm/setup-nvm.sh"
setup_nvm
print_footer "NVM set up"


print_header "Syncing VSCode settings ⚙️"
source "$ROOT_DIR/vscode/setup-vscode.sh"
sync_vscode_settings
print_footer "VSCode settings synced"
