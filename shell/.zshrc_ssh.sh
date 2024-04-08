#!/usr/bin/env zsh

setup_ssh() {
    for key in ~/.ssh/id_*; do
        if [[ ! $key =~ \.pub$ ]]; then
            ssh-add --apple-use-keychain $key
        fi
    done
}