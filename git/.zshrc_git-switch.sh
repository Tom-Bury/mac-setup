#!/usr/bin/env zsh

git_switch() {
  if [ "$1" = "-" ]; then
    # switch to the branch you were on before
    git switch -
  elif git show-ref --verify --quiet refs/heads/"$1"; then
    # switch to the branch you specified
    git switch "$1"
  else
    # switch to the branch you select with fzf
    git switch $(
        git branch | 
        fzf \
            --color='prompt:#af5fff,header:#262626,gutter:-1,pointer:#af5fff' \
            --reverse \
            --pointer="⏺" \
            --query="$1" | 
        tr -d '[:space:]'
    )
  fi
}

git_switch_remote() {
  git fetch --all

  if [ "$1" = "-" ]; then
    # switch to the branch you were on before
    git switch -
  elif git show-ref --verify --quiet refs/remotes/origin/"$1"; then
    # switch to the branch you specified
    git checkout "$1"
  else
    # switch to the branch you select with fzf
    local branch=$(git branch -r | 
        fzf \
            --color='prompt:#af5fff,header:#262626,gutter:-1,pointer:#af5fff' \
            --reverse \
            --pointer="⏺" \
            --query="$1" | 
        tr -d '[:space:]' | 
        sed 's#origin/##')
    git checkout -b "$branch" "origin/$branch"
  fi
}

alias gitsw=git_switch
alias gitswr=git_switch_remote