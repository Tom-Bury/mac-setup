#!/usr/bin/env zsh

add_ssh_keys() {
    for key in ~/.ssh/id_*; do
        ssh-add --apple-use-keychain $key
    done
}