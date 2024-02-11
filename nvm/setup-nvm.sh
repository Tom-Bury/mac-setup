#!/usr/bin/env zsh

setup_nvm() {
  if test ! "$(command -v nvm)"; then
    # https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  fi
}
