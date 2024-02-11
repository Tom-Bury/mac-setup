#!/usr/bin/env zsh

# Inspiration - General script
#
# - https://gist.github.com/codeinthehole/26b37efa67041e1307db
# - https://www.lotharschulz.info/2021/05/11/macos-setup-automation-with-homebrew/

ROOT_DIR="$(dirname "$0")"
source "$ROOT_DIR/utils.sh"


setup_zsh() {
  print_header "Setting up ZSH 🐚"
  
  # Use Oh My ZSH mainly for plugins
  # https://github.com/ohmyzsh/ohmyzsh
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  # Add StarShip prompt styling
  create_backup "$HOME/.config/starship.toml"
  cp "$ROOT_DIR/starship.toml" "$HOME/.config/starship.toml"

  # Add ZSH config
  create_backup "$HOME/.zshrc"
  cp "$ROOT_DIR/.zshrc" "$HOME/.zshrc"

  source $HOME/.zshrc

  # Set up autocomplete and syntax highlighting plugins
  # Inspiration: https://gist.github.com/n1snt/454b879b8f0b7995740ae04c5fb5b7df

  AUTOSUGGESTIONS_INSTALLATION_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  if [ ! -d $AUTOSUGGESTIONS_INSTALLATION_DIR ]; then
    git clone --depth 1 -- https://github.com/zsh-users/zsh-autosuggestions $AUTOSUGGESTIONS_INSTALLATION_DIR
  fi

  SYNTAX_HIGHLIGHTING_INSTALLATION_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
  if [ ! -d $SYNTAX_HIGHLIGHTING_INSTALLATION_DIR ]; then
    git clone --depth 1 -- https://github.com/zdharma-continuum/fast-syntax-highlighting.git $SYNTAX_HIGHLIGHTING_INSTALLATION_DIR
  fi

  AUTOCOMPLETE_INSTALLATION_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete
  if [ ! -d $AUTOCOMPLETE_INSTALLATION_DIR ]; then
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $AUTOCOMPLETE_INSTALLATION_DIR
  fi

  source $HOME/.zshrc

  # Autocompletion settings
  zstyle ':autocomplete:*' delay 0.1  # seconds (float)
  zstyle -e ':autocomplete:list-choices:*' list-lines 'reply=( $(( LINES / 3 )) )'
  zstyle ':autocomplete:history-incremental-search-backward:*' list-lines 8
  zstyle ':autocomplete:history-search-backward:*' list-lines 8
  
  print_footer "ZSH set up"
}

setup_nvm() {
  print_header "Setting up NVM 📦"
  if test ! "$(command -v nvm)"; then
    # https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  fi
  print_footer "NVM set up"
}


sudo -v # Ask for the administrator password upfront

print_header "Setting up OSX preferences 🖥"
source "$ROOT_DIR/osx/setup-osx.sh"
require_password_on_sleep
setup_typing_preferences
setup_finder
enable_snap_to_grid
expand_save_and_print_dialogs
setup_dock
setup_mission_control

killall Finder
killall Dock
print_footer "OSX preferences set up"


print_header "Creating folders 📂"
safe_create_folder $HOME/personal/code
safe_create_folder $HOME/work/code
print_footer "Folders created"


print_header "Installing HomeBrew 🍺"
source "$ROOT_DIR/homebrew/setup-homebrew.sh"
install_homebrew
print_footer "HomeBrew installed"

print_header "Downloading HomeBrew apps 📱"
download_homebrew_apps
print_footer "HomeBrew apps downloaded"


setup_zsh


setup_nvm


print_header "Syncing VSCode settings ⚙️"
source "$ROOT_DIR/vscode/setup-vscode.sh"
sync_vscode_settings
print_footer "VSCode settings synced"
