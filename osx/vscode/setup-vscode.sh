#!/usr/bin/env zsh

SETUP_VSCODE_SCRIPT_DIR="$(dirname "$0")"
VSCODE_SETTINGS="$HOME/Library/Application Support/Code/User/settings.json"
VSCODE_KEYBINDINGS="$HOME/Library/Application Support/Code/User/keybindings.json"

sync_vscode_settings() {
  # TODO: reconsider this approach if https://github.com/microsoft/issues/195539 (allowing VSCode to use symlinked settings files) is implemented
  while [[ ! $REPLY =~ ^[OoMm]$ ]]; do
    echo ""
    echo "Do you want to overwrite or merge VSCode settings? (o/m)"
    read "REPLY?Press o for overwrite, m for merge: "
    echo ""
  done

  create_backup "$VSCODE_SETTINGS"
  create_backup "$VSCODE_KEYBINDINGS"

  if [[ $REPLY =~ ^[Oo]$ ]]; then
    overwrite_vscode_settings
  elif [[ $REPLY =~ ^[Mm]$ ]]; then
    merge_vscode_settings
  fi
}

overwrite_vscode_settings() {
  cp "$SETUP_VSCODE_SCRIPT_DIR/vscode-settings.json" "$VSCODE_SETTINGS"
  cp "$SETUP_VSCODE_SCRIPT_DIR/vscode-keybindings.json" "$VSCODE_KEYBINDINGS"
  echo "VSCode settings overwritten"  
}

merge_vscode_settings() {  
  jq -s '.[0] + .[1]' "$SETUP_VSCODE_SCRIPT_DIR/vscode-settings.json" "$VSCODE_SETTINGS" > "$SETUP_VSCODE_SCRIPT_DIR/tmp.json"
  if [ $? -eq 0 ]; then
    cp "$SETUP_VSCODE_SCRIPT_DIR/tmp.json" "$SETUP_VSCODE_SCRIPT_DIR/vscode-settings.json"
    cp "$SETUP_VSCODE_SCRIPT_DIR/tmp.json" "$VSCODE_SETTINGS"
    echo "VSCode settings merged and local files updated with the result. Check for changes and commit them!"
  else
    echo "❌ VSCode settings merge failed. Reverting changes. Please sync manually."
  fi

  if [ -f "$SETUP_VSCODE_SCRIPT_DIR/tmp.json" ]; then
    rm "$SETUP_VSCODE_SCRIPT_DIR/tmp.json"
  fi

  jq -s 'add | unique' "$SETUP_VSCODE_SCRIPT_DIR/vscode-keybindings.json" "$VSCODE_KEYBINDINGS" > "$SETUP_VSCODE_SCRIPT_DIR/tmp.json"
  if [ $? -eq 0 ]; then
    cp "$SETUP_VSCODE_SCRIPT_DIR/tmp.json" "$SETUP_VSCODE_SCRIPT_DIR/vscode-keybindings.json"
    cp "$SETUP_VSCODE_SCRIPT_DIR/tmp.json" "$VSCODE_KEYBINDINGS"
    echo "VSCode keybindings merged and local files updated with the result. Check for changes and commit them!"
  else
    echo "❌ VSCode keybindings merge failed. Reverting changes. Please sync manually."
  fi

  if [ -f "$SETUP_VSCODE_SCRIPT_DIR/tmp.json" ]; then
    rm "$SETUP_VSCODE_SCRIPT_DIR/tmp.json"
  fi
}
