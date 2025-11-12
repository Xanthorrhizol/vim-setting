#!/bin/bash
set -euo pipefail
cd $(dirname "${BASH_SOURCE[0]}")

echo "It will replace your original vim setting"
read -p "agree?[y/N]: " agree
if [ $(echo $agree | grep -i y | wc -l) -eq 0 ]; then
  echo "bye"
  exit 0
fi

read -p "It needs npm. Did you install npm?[y/N]: " yes
if [[ ! "$yes" == "y" ]] && [[ ! "$yes" == "Y" ]]; then
  echo "Please install npm first"
  exit -1
fi
npm install -g prettier

if ! [ -d $HOME/.vim ]; then
  mkdir $HOME/.vim
fi
if ! [ -d $HOME/.local/bin ]; then
  mkdir -p $HOME/.local/bin
fi

if ! [ -d $HOME/.config/coc ]; then
  mkdir -p $HOME/.config/coc
fi

read -p "Do you want to use autocomplete agent?[y/N]: " yes
if [[ "$yes" == "y" ]] || [[ "$yes" == "Y" ]]; then
  while true; do
    read -p "Which one? [copilot|windsurf(codeium)]: " ai
    case $ai in
      copilot)
        vim  -c "Copilot setup"
        break
        ;;
      windsurf|codeium)
        vim -c "Codeium Auth"
        break
        ;;
      *)
        ;;
    esac
  done
fi

cp -r vim/* $HOME/.vim/
cp vimrc $HOME/.vimrc

while true; do
  read -p "What's your linux system kind [arch(pacman)/debian(apt)/fedora(yum/dnf)]: " DISTRO
  if [[ "$DISTRO" == "arch" ]] || [[ "$DISTRO" == "pacman" ]]; then
    sudo pacman -S pkg-config libunwind
    break
  elif [[ "$DISTRO" == "debian" ]] || [[ "$DISTRO" == "apt" ]] || [[ "$DISTRO" == "ubuntu" ]]; then
    sudo apt install -y pkg-config libunwind-dev # not tested
    break
  elif [[ "$DISTRO" == "fedora" ]] || [[ "$DISTRO" == "yum" ]] || [[ "$DISTRO" == "dnf" ]]; then
    sudo yum -y install pkg-config libunwind-dev # not tested
    break
  fi
done

echo "install plugins and language servers"
vim -c "PlugUpdate | PlugUpgrade | PlugInstall | q | q"
vim -c "CocUpdate"
vim -c "CocInstall coc-sh coc-rust-analyzer coc-clangd coc-markdownlint coc-tsserver coc-eslint coc-json coc-docker coc-groovy coc-python"
echo "done"

echo "do you want to setup ctags? [y/N]"
read yes
if [ $(echo $yes | grep -i y | wc -l) -ne 1 ]; then
  echo "bye"
  exit 0
fi

echo "did you installed rustc, cargo? [y/N]"
read yes
if [ $(echo $yes | grep -i y | wc -l) -ne 1 ]; then
  echo "install rustc, cargo"
  exit -1
fi

while true; do
  if [[ "$DISTRO" == "arch" ]] || [[ "$DISTRO" == "pacman" ]]; then
    sudo pacman -S ctags
    break
  elif [[ "$DISTRO" == "debian" ]] || [[ "$DISTRO" == "apt" ]] || [[ "$DISTRO" == "ubuntu" ]]; then
    sudo apt install -y ctags # not tested
    break
  elif [[ "$DISTRO" == "fedora" ]] || [[ "$DISTRO" == "yum" ]] || [[ "$DISTRO" == "dnf" ]]; then
    sudo yum -y install ctags # not tested
    break
  fi
done

cargo install rusty-tags
rustup component add rust-src rust-analyzer
SHELLRC="$HOME/.$(echo $SHELL | cut -d '/' -f 3)rc"
if [ $(rustc --version | awk '{ print $2 }' | cut -d '-' -f 1 | cut -d '.' -f 2) -ge 47 ]; then
  ENV_TO_ADD='export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/library/'
else
  ENV_TO_ADD='export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/src/'
fi
if [ $(cat $SHELLRC | grep RUST_SRC_PATH | wc -l) -eq 0 ]; then
  echo $ENV_TO_ADD >> $SHELLRC
fi
mkdir -p $HOME/.rusty-tags
cp -f config.toml $HOME/.rusty-tags/

cargo install bugstalker
