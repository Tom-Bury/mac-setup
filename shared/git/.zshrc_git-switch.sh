#!/usr/bin/env zsh

git_switch() {
  STASH_NAME="autostash_$(git rev-parse --abbrev-ref HEAD)_$(date +%Y-%m-%d)"
  git stash -q -u -m $STASH_NAME
  STASH_REF=$(git stash list | grep $STASH_NAME | awk -F: '{print $1}' || echo "")
  if [[ -n $STASH_REF ]]; then
    trap "git stash pop -q $STASH_REF" EXIT
  fi

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
  STASH_NAME="autostash_$(git rev-parse --abbrev-ref HEAD)_$(date +%Y-%m-%d)"
  git stash -q -u -m $STASH_NAME
  STASH_REF=$(git stash list | grep $STASH_NAME | awk -F: '{print $1}' || echo "")
  if [[ -n $STASH_REF ]]; then
    trap "git stash pop -q $STASH_REF" EXIT
  fi

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