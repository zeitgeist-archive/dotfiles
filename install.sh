#!/bin/bash
echo "Setting up dotfiles..."

# 1. Create symlinks
ln -sf ~/dotfiles/.vimrc ~/.vimrc
mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/nvim/init.vim ~/.config/nvim/init.vim

# 2. Install vim-plug for classic Vim
if [ ! -f ~/.vim/autoload/plug.vim ]; then
    echo "Installing vim-plug for Vim..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# 3. Install vim-plug for Neovim
if [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
    echo "Installing vim-plug for Neovim..."
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# 4. Initialize the default theme state to prevent startup errors
if [ ! -f ~/.vim/current_theme ]; then
    echo "gruvbox" > ~/.vim/current_theme
fi

# 5. Automatically install all plugins
echo "Installing plugins for Vim..."
vim -E -s -c "source ~/.vimrc" -c PlugInstall -c qa || true

echo "Installing plugins for Neovim..."
nvim --headless -c "PlugInstall" -c qa || true

echo "Setup complete! Your environment is now fully replicated."
