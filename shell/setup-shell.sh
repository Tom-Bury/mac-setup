#!/usr/bin/env zsh

SCRIPT_DIR="$(dirname "$0")"

setup_shell() {
  install_oh_my_zsh
  setup_starship_prompt
  setup_zshrc

  # Set up autocomplete and syntax highlighting plugins
  # Inspiration: https://gist.github.com/n1snt/454b879b8f0b7995740ae04c5fb5b7df
  setup_autosuggestions
  setup_syntax_highlighting
  setup_zsh_autocomplete

  setup_extra_source_scripts

  source $HOME/.zshrc  
}

install_oh_my_zsh() {
  # Use Oh My ZSH mainly for plugins
  # https://github.com/ohmyzsh/ohmyzsh
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
}

setup_starship_prompt() {
  # https://starship.rs/
  # Installed through homebrew
  create_backup "$HOME/.config/starship.toml"
  cp "$SCRIPT_DIR/starship.toml" "$HOME/.config/starship.toml"
}

setup_zshrc() {
  # Add ZSH config
  create_backup "$HOME/.zshrc"
  cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
  source $HOME/.zshrc
}

setup_autosuggestions() {
  AUTOSUGGESTIONS_INSTALLATION_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  if [ ! -d $AUTOSUGGESTIONS_INSTALLATION_DIR ]; then
    git clone --depth 1 -- https://github.com/zsh-users/zsh-autosuggestions $AUTOSUGGESTIONS_INSTALLATION_DIR
  fi
}

setup_syntax_highlighting() {
  SYNTAX_HIGHLIGHTING_INSTALLATION_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
  if [ ! -d $SYNTAX_HIGHLIGHTING_INSTALLATION_DIR ]; then
    git clone --depth 1 -- https://github.com/zdharma-continuum/fast-syntax-highlighting.git $SYNTAX_HIGHLIGHTING_INSTALLATION_DIR
  fi
}

setup_zsh_autocomplete() {
  AUTOCOMPLETE_INSTALLATION_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete
  if [ ! -d $AUTOCOMPLETE_INSTALLATION_DIR ]; then
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $AUTOCOMPLETE_INSTALLATION_DIR
  fi

  # Autocompletion settings
  zstyle ':autocomplete:*' delay 0.1  # seconds (float)
  zstyle -e ':autocomplete:list-choices:*' list-lines 'reply=( $(( LINES / 3 )) )'
  zstyle ':autocomplete:history-incremental-search-backward:*' list-lines 8
  zstyle ':autocomplete:history-search-backward:*' list-lines 8
}

setup_extra_source_scripts() {
  DEST_DIR="$HOME/zshrc-scripts"

  [ -d "$DEST_DIR" ] || mkdir -p "$DEST_DIR"

  # Define the source files
  SOURCE_FILES_PREFIX=".zshrc_"
  SOURCE_FILES=($(find "$SCRIPT_DIR/.." -type f -name "$SOURCE_FILES_PREFIX*.sh"))

  # Loop over the source files
  for SOURCE_FILE in "${SOURCE_FILES[@]}"; do
    # Extract the filename from the source file path
    FILENAME=$(basename "$SOURCE_FILE")

    # Check if the source file exists and copy it
    if [ -f "$SOURCE_FILE" ]; then
      cp "$SOURCE_FILE" "$DEST_DIR/$FILENAME"
    else
      echo "Source file $SOURCE_FILE does not exist."
    fi

    # Source it
    echo "source $DEST_DIR/$FILENAME" >> "$HOME/.zshrc"
  done
}