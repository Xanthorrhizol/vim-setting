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
