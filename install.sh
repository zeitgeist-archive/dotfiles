#!/bin/bash
echo "Setting up dotfiles..."
# Create symlinks (force overwrite if existing defaults are there)
ln -sf ~/dotfiles/.vimrc ~/.vimrc
mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/nvim/init.vim ~/.config/nvim/init.vim
echo "Symlinks created successfully!"
