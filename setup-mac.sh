#!/usr/bin/env zsh

# Inspiration - General script
#
# - https://gist.github.com/codeinthehole/26b37efa67041e1307db
# - https://www.lotharschulz.info/2021/05/11/macos-setup-automation-with-homebrew/

ROOT_DIR="$(dirname "$0")"
DATETIME_FORMAT="%Y-%m-%d_%H-%M-%S"

source "$ROOT_DIR/osx-preferences.sh"

print_header() {
  echo "=== $1 ==="
}

print_footer() {
  echo "=== $1 ✅ ==="
  echo ""
}

setup_osx_preferences() {
  print_header "Setting up OSX preferences 🖥"
  
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
}

install_homebrew() {
  # https://brew.sh/
  print_header "Installing HomeBrew 🍺" 
  if test ! $(which brew); then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/tom.bury/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  brew update
  brew upgrade
  print_footer "HomeBrew installed"
}

download_homebrew_apps() {
  # Install any Homebrew packages, Mac Apps or VSCode extensions using a Brewfile
  # https://docs.brew.sh/Manpage#bundle-subcommand
  # https://github.com/Homebrew/homebrew-bundle
  print_header "Downloading HomeBrew apps 📱"
  brew bundle --file="$ROOT_DIR/Brewfile"
  print_footer "HomeBrew apps downloaded"
}

create_backup() {
  mkdir -p "$HOME/.mac-setup-backups/"
  cp "$1" "$HOME/.mac-setup-backups/$(basename $1)_$(date +$DATETIME_FORMAT)"
}

setup_zsh() {
  print_header "Setting up ZSH 🐚"
  
  # Use Oh My ZSH mainly for plugins
  # https://github.com/ohmyzsh/ohmyzsh
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  # Add StarShip prompt styling
  if [ -f "$HOME/.config/starship.toml" ]; then
    create_backup "$HOME/.config/starship.toml"
  fi
  cp "$ROOT_DIR/starship.toml" "$HOME/.config/starship.toml"

  # Add ZSH config
  if [ -f "$HOME/.zshrc" ]; then
    create_backup "$HOME/.zshrc"
  fi
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



safe_create_folder() {
  folder_path=$1
  if [[ ! -d $folder_path ]]; then
    mkdir -p $folder_path
    echo -e "- created $folder_path folder 🆕"
  else
    echo -e "- $folder_path folder already exists 🗂"
  fi
}

create_folders() {
  print_header "Creating folders 📂"
  safe_create_folder $HOME/personal/code
  safe_create_folder $HOME/work/code
  print_footer "Folders created"
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
setup_osx_preferences
create_folders
install_homebrew
download_homebrew_apps
setup_zsh
setup_nvm
