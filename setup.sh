#!/usr/bin/env bash

set -eu

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

BREW_PKGS=(
  brew-cask
  emacs
  git
  go
  htop-osx
  multitail
  pt
  tmux
  vim
  wget
  zsh
  gauche
  rlwrap
  qt
  v8
  redis
  pigz
  netcat
  rust
  opencv
  gnuplot
  spark
  plotutils
  openssl
  docker
  docker-machine
  docker-swarm
  docker-compose
  ngrok
  terminal-notifier
  awscli
  socat
  jq
  fpp
  nkf
  hugo
  tree
  pup
  gnu-sed
  leiningen
)

BREW_CASK_PKGS=(
  alfred
  android-studio
  dropbox
  evernote
  firefox
  google-chrome
  google-japanese-ime
  hyperswitch
  inkscape
  iterm2
  java
  kobito
  skype
  slack
  sophos-anti-virus-home-edition
  sourcetree
  vagrant
  virtualbox
  xquartz
  yorufukurou
  gimp
  flush-player
  libreoffice
  kitematic
  mysqlworkbench
  the-unarchiver
  brackets
  limechat
  otto
)

MY_PROJ_DIR=$HOME/myproj

MY_GIT_REPOS=(
  "git@github.com:eji/dot-files.git"
  "git@github.com:eji/tableau-study-session.git"
  "git@github.com:eji/mix-kenall-geocode.git"
  "git@github.com:eji/study-of-data-analysis.git"
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

# ユーザー共通の設定

## マルチユーザーでHomebrewを使うための設定
grep "umask 0002" "/etc/profile" 2>&1 1>/dev/null
if [ $? -ne 0 ] ; then
  sudo sh -c "echo 'umask 0002' >> /etc/profile"
fi
grep "umask 0002" "/etc/zprofile" 2>&1 1>/dev/null
if [ $? -ne 0 ] ; then
  sudo sh -c "echo 'umask 0002' >> /etc/zprofile"
fi
umask 0002

## 既にHomebrewのパッケージがインストールされている場合は、ディレクトリのパーミッションを変更する
sudo chmod -R g+w /usr/local
sudo chgrp -R staff /usr/local
sudo chmod -R g+w /opt/homebrew-cask
sudo chgrp -R staff /Library/Caches/Homebrew
sudo chmod -R g+w /Library/Caches/Homebrew

## パッケージのインストール
brew update
brew upgrade

brew tap caskroom/cask || true
brew tap homebrew/binary || true
brew tap homebrew/versions || true
brew tap homebrew/science || true

for i in ${BREW_PKGS[@]}; do
        install_brew $i
done

for i in ${BREW_CASK_PKGS[@]}; do
        install_brew_cask $i
done

brew cask alfred link || true

brew cleanup
brew cask cleanup

# Python
sudo easy_install pip
sudo pip install mercurial

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
vim -c "NeoBundleInstall"
popd

notice "setup my work env"
pushd $MY_PROJ_DIR/work-env
git pull
./setup.sh
popd

