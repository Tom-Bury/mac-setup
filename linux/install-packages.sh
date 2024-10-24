#!/usr/bin/env zsh

PACKAGES=(
  "ffmpeg"
  "fzf"
  "tree"
)

main() {
  sudo apt-get update
  sudo apt-get upgrade -y

  for package in ${PACKAGES[@]}; do
    if ! dpkg -l | grep -q $package; then
      echo "Installing $package"
      sudo apt-get install -y $package
    else
      echo "$package is already installed"
    fi
  done

  # Install StarShip
  if ! command -v starship &> /dev/null; then
    install_starship
  else
    echo "" & echo "🚀 Starship is already installed"
  fi
}

main