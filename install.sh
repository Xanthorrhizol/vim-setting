#!/bin/bash
cd $(dirname "${BASH_SOURCE[0]}")
echo "It will replace your original vim setting"
echo "agree?[y/N]"
read agree
if [ $(echo $agree | grep -i y | wc -l) -eq 0 ]; then
  echo "bye"
  exit 0
fi
if ! [ -d $HOME/.vim ]; then
  mkdir $HOME/.vim
fi
if ! [ -d $HOME/.local/bin ]; then
  mkdir -p $HOME/.local/bin
fi

cp -r vim/* $HOME/.vim/
cp vimrc $HOME/.vimrc
cp rust-analyzer $HOME/.local/bin

echo "install plugins and language servers"
vim -c "PlugInstall | q | q"
vim -c "CocInstall coc-sh coc-rust-analyzer coc-clangd coc-markdownlint coc-tsserver coc-json coc-docker coc-rls"
echo "done"

echo "do you want to setup ctags?"
read yes
if [ $(echo $yes | grep -i y | wc -l) -ne 1 ]; then
  echo "bye"
  exit 0
fi

echo "did you installed rustc, cargo?"
read yes
if [ $(echo $yes | grep -i y | wc -l) -ne 1 ]; then
  echo "install rustc, cargo"
  exit -1
fi
cargo install rusty-tags
rustup component add rust-src
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
