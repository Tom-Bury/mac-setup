#!/usr/bin/env zsh

# Inspiration - Change OSX settings
# - https://gist.github.com/MatthewMueller/e22d9840f9ea2fee4716
# - https://macos-defaults.com/

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
  # When performing a search, search the current folder by default
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
}

enable_snap_to_grid() {
  # Enabling snap-to-grid for icons on the desktop and in other icon views
  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" $HOME/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" $HOME/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" $HOME/Library/Preferences/com.apple.finder.plist
}

expand_save_and_print_dialogs() {
  # Expanding the save and print dialogs
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
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
}

setup_mission_control() {
  # Group windows by application
  defaults write com.apple.dock "expose-group-apps" -bool "true"
}

setup_typing_preferences() {
  # Disable smart quotes and dashes as they’re annoying when typing code
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
  
  # Set keyboard repeat rate
  defaults write -g InitialKeyRepeat -int 15 # normal minimum is 15 (225 ms)
  defaults write -g KeyRepeat -int 2 # normal minimum is 2 (30 ms)
  
  # Disable auto-correct
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
  
  # Disable press-and-hold for keys in favor of key repeat
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
}

setup_simulators() {
  # Show touches in the iOS simulator
  defaults write com.apple.iphonesimulator ShowSingleTouches 1
}