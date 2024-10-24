#!/bin/bash

sudo apt update
sudo apt install zsh -y

chsh -s $(which zsh)