#!/usr/bin/env zsh

# Git Fork GUI custom command to create a pull request into a specific branch
# unsure if this works for non-bitbucket repos

# source: https://github.com/sfinktah/bash/blob/master/rawurlencode.inc.sh
rawurlencode() {
    local string="${1}"
    local strlen=${#string}
    local encoded=""
    local pos c o

    for (( pos=0 ; pos<strlen ; pos++ )); do
        c=${string:$pos:1}
        case "$c" in
           [-_.~a-zA-Z0-9] ) o="${c}" ;;
           * )               printf -v o '%%%02x' "'$c"
        esac
        encoded+="${o}"
    done
    echo "${encoded}"    # You can either set a return variable (FAASTER) 
    REPLY="${encoded}"   # or echo the result (EASIER)... or both... :p
}

fetch_remote_url_for_repo_path() {
    local remote_url=$(git -C "$1" remote get-url origin)
    echo "${remote_url}"
}
get_target_branch() {
    local target_branch=$1

    # If no target branch is provided, use fzf to select one
    if [ -z "$target_branch" ]; then
        target_branch=$(git branch -r | grep -v "HEAD" | fzf --prompt='Branch to PR into > ')
    fi

    # Trim the 'origin/' part of the target branch
    target_branch=$(echo $target_branch | sed 's/origin\///' | tr -d '[:space:]')

    echo $target_branch
}

create_pull_request() {
    local platform=$1
    local target_branch=$(get_target_branch $2)
    local curr_branch=$(git rev-parse --abbrev-ref HEAD)

    echo "Creating pull request from $curr_branch to $target_branch on $platform"

    local repo_ssh_url=$(fetch_remote_url_for_repo_path .)
    local url_wip=${repo_ssh_url/:/\/}
    url_wip="https://${url_wip/git@/}"
    local repo_https_url=${url_wip%.git}

    local url
    if [ "$platform" = "Bitbucket" ]; then
        url="$repo_https_url/pull-requests/new?source=$(rawurlencode $curr_branch)&dest=$(rawurlencode $target_branch)"
    else
        url="$repo_https_url/compare/$target_branch...$curr_branch"
    fi

    open $url > /dev/null 2>&1
}

create_bb_pull_request() {
    create_pull_request "Bitbucket" $1
}

alias gitbb='create_bb_pull_request'

create_gh_pull_request() {
    create_pull_request "GitHub" $1
}

alias gitgh='create_gh_pull_request'