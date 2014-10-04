#!/usr/bin/env bash

set -eu

MY_PROJ_DIR=$HOME/myproj

MY_GIT_REPOS=(
  "git@github.com:eji/dot-files.git"
  "git@github.com:eji/tableau-study-session.git"
  "git@github.com:eji/mix-kenall-geocode.git"
  "git@github.com:eji/study-of-data-analysis.git"
)

W_COLOR=$'\e[0;31m'
N_COLOR=$'\e[0m'

warning()
{
      echo $W_COLOR "WARNING: $@" $N_COLOR >&2
}

notice()
{
      echo $N_COLOR "$@"
}

deltect_dirname_from_gitrepo() {
        local REPO=$1
        echo $REPO | sed 's|^.*/\(.*\)\.git$|\1|'
}

git_clone()
{
        local REPO=$1
        local REPO_DIR=$(deltect_dirname_from_gitrepo $REPO)
        if [ -d "$REPO_DIR" ]; then
                warning "$REPO_DIR dir already exist"
        else
                git clone $REPO
        fi
}

if [ ! -d "$MY_PROJ_DIR" ]; then
        notice "create projects dirs:"
        notice "  mkdir $MY_PROJ_DIR"
        mkdir $MY_PROJ_DIR
fi
cd $MY_PROJ_DIR

for i in ${MY_GIT_REPOS[@]}; do
        git_clone $i
done

