#!/usr/bin/env zsh

git_switch() {
  if [ "$1" = "-" ]; then
    # switch to the branch you were on before
    git switch -
  elif git show-ref --verify --quiet refs/heads/"$1"; then
    # switch to the branch you specified
    git switch "$1"
  else
    # switch to the branch you selected with fzf
    git switch $(git branch | fzf| tr -d '[:space:]')
  fi
}

alias gitsw=git_switch