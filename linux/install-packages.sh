#!/usr/bin/env zsh

PACKAGES=(
  "ffmpeg"
  "fzf"
)

install_packages() {
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
  curl -sS https://starship.rs/install.sh | sh
}