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

BREW_PKGS_LINUX=(
  xclip
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
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    setup_homebrew_linux
    install_packages_linux
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    setup_homebrew_macosx
    install_packages_macosx
  else
    warn "Unsupported OSTYPE: $OSTYPE"
    exit 1
  fi

  install_packages_common

  brew update
  brew upgrade
}

setup_homebrew_linux()
{
  if ! command_exists brew; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
  fi
  # 環境変数SHELLによって返す設定値が異なるため、明示的にSHELLを設定している
  test -d /home/linuxbrew/.linuxbrew && eval $(SHELL=/bin/bash /home/linuxbrew/.linuxbrew/bin/brew shellenv)

  apt install build-essential lxd lxd-client
}

setup_homebrew_macosx()
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

install_packages_macosx()
{
  for i in ${BREW_PKGS_MACOSX[@]}; do
    brew install $i
  done
}

install_packages_linux()
{
  for i in ${BREW_PKGS_LINUX[@]}; do
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
