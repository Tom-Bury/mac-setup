#!/usr/bin/env zsh

# Inspiration - General script
#
# - https://gist.github.com/codeinthehole/26b37efa67041e1307db
# - https://www.lotharschulz.info/2021/05/11/macos-setup-automation-with-homebrew/

# Inspiration - Change OSX settings
# - https://gist.github.com/MatthewMueller/e22d9840f9ea2fee4716
# - https://macos-defaults.com/

ROOT_DIR="$(dirname "$0")"
DATETIME_FORMAT="%Y-%m-%d_%H-%M-%S"

setup_homebrew() {
  # https://brew.sh/
  echo "Setting up HomeBrew"
  if test ! $(which brew); then
    echo " -> Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/tom.bury/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  brew update
  brew upgrade
  echo -e " -> HomeBrew installed  ✅\n\n"
}

download_homebrew_apps() {
  # Install any Homebrew packages, Mac Apps or VSCode extensions using a Brewfile
  # https://docs.brew.sh/Manpage#bundle-subcommand
  # https://github.com/Homebrew/homebrew-bundle
  echo "Installing HomeBrew apps"
  brew bundle --file="$ROOT_DIR/Brewfile"
  echo -e " -> HomeBrew apps installed  ✅\n\n"
}

setup_zsh() {
  echo "Setting up ZSH"
  
  # Use Oh My ZSH mainly for plugins
  # https://github.com/ohmyzsh/ohmyzsh
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  # Add StarShip prompt styling
  if [ -f "$HOME/.config/starship.toml" ]; then
    cp "$HOME/.config/starship.toml" "$HOME/.config/starship_mac-setup-backup_$(date +$DATETIME_FORMAT).toml"
  fi
  cp "$ROOT_DIR/starship.toml" "$HOME/.config/starship.toml"

  # Add ZSH config
  if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc_mac-setup-backup_$(date +$DATETIME_FORMAT)"
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
  echo -e " -> ZSH set up  ✅\n\n"
}

require_password_on_sleep() {
  # Require password as soon as screensaver or sleep mode starts
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 0
}

setup_finder() {
  # Showing all filename extensions in Finder by default
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  # Allowing text selection in Quick Look/Preview in Finder by default
  defaults write com.apple.finder QLEnableTextSelection -bool true
  # Displaying full POSIX path as Finder window title
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
  # Disabling the warning when changing a file extension
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
  # Show hidden files
  defaults write com.apple.finder "AppleShowAllFiles" -bool "true"
  # Default to list view
  defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"
  # Remove the delay when hovering the toolbar title 
  defaults write NSGlobalDomain "NSToolbarTitleViewRolloverDelay" -float "0"
  # Keep folders on top when sorting by name
  defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"

  killall Finder
}

enable_snap_to_grid() {
  # Enabling snap-to-grid for icons on the desktop and in other icon views
  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" $HOME/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" $HOME/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" $HOME/Library/Preferences/com.apple.finder.plist

  killall Finder
}

expand_save_and_print_dialogs() {
  # Expanding the save and print dialogs
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

  killall Finder
}

setup_dock() {
  # Automatically hide and show the Dock
  defaults write com.apple.dock "autohide" -bool "true"
  # Remove the auto-hiding Dock delay
  defaults write com.apple.dock "autohide-delay" -float "0"
  # Disable recents in dock
  defaults write com.apple.dock "show-recents" -bool "false"
  # Enable scroll up on a Dock icon to show all Space's opened windows for an app
  defaults write com.apple.dock "scroll-to-open" -bool "true"
  # Scale apps when minifying instead of the default genie effect
  defaults write com.apple.dock "mineffect" -string "scale"
  # Decrease Dock animation speed
  defaults write com.apple.dock expose-animation-duration -float 0.1
  
  killall Dock
}

setup_mission_control() {
  # Group windows by application
  defaults write com.apple.dock "expose-group-apps" -bool "true"
  
  killall Dock
}

setup_typing_preferences() {
  # Disable smart quotes and dashes as they’re annoying when typing code
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
}

setup_osx_preferences() {
  echo "Setting up OSX preferences"
  require_password_on_sleep
  setup_typing_preferences
  setup_finder
  enable_snap_to_grid
  expand_save_and_print_dialogs
  setup_dock
  setup_mission_control
  echo -e " -> OSX preferences set  ✅\n\n"
}

safe_create_folder() {
  folder_path=$1
  if [[ ! -d $folder_path ]]; then
    mkdir $folder_path
    echo -e "Created $folder_path folder ✅\n\n"
  else
    echo -e "$folder_path folder already exists ✅\n\n"
  fi
}

setup_nvm() {
  # https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating
  echo "Setting up NVM"
  if test ! "$(command -v nvm)"; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  fi
  echo -e " -> NVM set up  ✅\n\n"
}


sudo -v # Ask for the administrator password upfront
setup_osx_preferences
safe_create_folder $HOME/personal
safe_create_folder $HOME/personal/code
safe_create_folder $HOME/work
safe_create_folder $HOME/work/code
setup_zsh
setup_nvm
setup_homebrew
download_homebrew_apps
