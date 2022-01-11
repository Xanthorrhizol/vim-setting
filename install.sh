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
cp -r vim/* $HOME/.vim/
cp vimrc $HOME/.vimrc

echo "install plugins and language servers"
vim -c "PlugInstall | q | q"
vim -c "CocInstall coc-sh coc-rust-analyzer coc-clangd coc-markdownlint coc-tsserver coc-json coc-docker"
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
if [ $(rustc --version | awk '{ print $2 }' | cut -d '-' -f 1 | cut -d '.' -f 2) -ge 47 ]; then
  echo 'export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/library/'
else
  echo 'export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/src/'
fi
mkdir -p $HOME/.rusty-tags
cp -f config.toml $HOME/.rusty-tags/
