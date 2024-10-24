#!/usr/bin/env zsh

PACKAGES=(
  "ffmpeg"
  "fzf"
  "tree"
)

main() {
  local SCRIPT_DIR=$1
  source $SCRIPT_DIR/../utils.sh

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

  install_starship
  install_go

  setup_extra_source_scripts $SCRIPT_DIR
}

install_starship() {
  # Install StarShip
  if ! command -v starship &> /dev/null; then
    echo "" && echo "Installing Starship 🚀" && echo ""
    curl -sS https://starship.rs/install.sh | sh
  else
    echo "" && echo "🚀 Starship is already installed" && echo ""
  fi
}

install_go() {
  local GO_VERSION="1.23.2"
  local GO_PACKAGE="go$GO_VERSION.linux-amd64.tar.gz"
  
  if ! command -v go &> /dev/null; then
    echo "" && echo "Installing Go 🐹" && echo ""
    wget "https://go.dev/dl/$GO_PACKAGE"
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf $GO_PACKAGE
    rm $GO_PACKAGE
  else
    echo "" && echo "🐹 Go is already installed" && echo ""
  fi
}

main $(dirname $0)