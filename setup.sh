#!/usr/bin/env bash

set -eu

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

BREW_PKGS=(
  multitail
  pt
  tmux
  newvim
  wget
  fish
  netcat
  terminal-notifier
  awscli
  socat
  jq
  jp
  fpp
  tree
  pup
  gnu-sed
  freetds
  rbenv
  ruby-build
  direnv
)

MY_PROJ_DIR=$HOME/myproj

MY_GIT_REPOS=(
  "git@github.com:eji/dot-files.git"
  "git@bitbucket.org:eji/work-env.git"
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

install_brew()
{
  brew install $1
}

install_brew_cask()
{
  brew cask install $1 || true
}

deltect_dirname_from_gitrepo()
{
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

## パッケージのインストール
brew update
brew upgrade

for i in ${BREW_PKGS[@]}; do
        install_brew $i
done

brew cleanup


if [ ! -d "$MY_PROJ_DIR" ]; then
        notice "create projects dirs:"
        notice "  mkdir $MY_PROJ_DIR"
        mkdir $MY_PROJ_DIR
fi
cd $MY_PROJ_DIR

for i in ${MY_GIT_REPOS[@]}; do
        git_clone $i
done

notice "setup dot files"
pushd $MY_PROJ_DIR/dot-files
git submodule init
git submodule update
./setup.sh
popd

notice "setup my work env"
pushd $MY_PROJ_DIR/work-env
git pull
./setup.sh
popd
