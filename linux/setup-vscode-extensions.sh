#!/usr/bin/env zsh

main() {
  SCRIPT_DIR=$1
  BREWFILE="$SCRIPT_DIR/../osx/homebrew/Brewfile"

  # Check if the Brewfile exists
  if [[ ! -f "$BREWFILE" ]]; then
      echo "Brewfile not found at $BREWFILE, expected it to install listed VSCode extensions."
      exit 1
  fi

  # Extract and install VSCode extensions
  grep "vscode \"" "$BREWFILE" | while read -r line; do
    extension_id=$(echo "$line" | sed -n "s/.*vscode \"\([^\"]*\)\".*/\1/p") 

    if [[ -n "$extension_id" ]]; then
      echo "Installing VSCode extension: $extension_id"
      code --install-extension "$extension_id"
    fi
  done
}

main $(dirname "$0")
