#!/usr/bin/env bash

set -eu

W_COLOR=$'\e[0;31m'
N_COLOR=$'\e[0m'

BREW_PKGS=(
  ghq
  ripgrep
  fzf
  tmux
  neovim
  wget
  fish
  nushell
  netcat
  awscli
  azure-cli
  socat
  jq
  jp
  fpp
  tree
  pup
  gnu-sed
  rbenv
  ruby-build
  nodenv
  direnv
)

BREW_PKGS_MACOSX=(
  terminal-notifier
)

warn()
{
  echo $W_COLOR "WARNING: $@" $N_COLOR >&2
}

notice()
{
  echo $N_COLOR "$@"
}

command_exists()
{
  type -p $1 > /dev/null
}

setup_homebrew_and_install_packages()
{
  setup_homebrew_macos
  install_packages_macos
  install_packages_common

  brew update
  brew upgrade
}

setup_homebrew_macos()
{
  if ! command_exists brew; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
}

install_packages_common()
{
  for i in ${BREW_PKGS[@]}; do
    brew install $i
  done
}

install_packages_macos()
{
  for i in ${BREW_PKGS_MACOSX[@]}; do
    brew install $i
  done
}

notice "Setup Homebrew and install packages"
setup_homebrew_and_install_packages

notice "Setup dot files"
ghq get "git@github.com:eji/dot-files.git"
pushd $(ghq root)/github.com/eji/dot-files
./setup.sh
popd
