#!/bin/bash

function install_rc()
{
  echo "installing '$1'.."
  if [ -e "$HOME/.$1" ] && [ ! -L "$HOME/.$1" ]; then
    mv "$HOME/.$1" "$HOME/.$1.old"
  fi
  ln -sfn "$DIR/$1" "$HOME/.$1"
}

DIR="$( cd "$( dirname "$0" )" && pwd )"
install_rc screenrc
install_rc vimrc
install_rc tmux.conf
install_rc bashrc
install_rc zshrc
install_rc p10k.zsh

install_rc gitignore_global
install_rc gitconfig

if [[ "$SHELL" != */zsh ]] && command -v zsh >/dev/null; then
  chsh -s "$(command -v zsh)"
fi

mkdir -p ~/bin

BREW=""
if [[ -e /usr/local/bin/brew ]]; then
  BREW="/usr/local/bin/brew"
fi
if [[ -e /opt/homebrew/bin/brew ]]; then
  BREW="/opt/homebrew/bin/brew"
fi

if [[ -e $BREW ]]; then
  $BREW bundle --file="$DIR/Brewfile"
  $($BREW --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
fi

# neovim
mkdir -p ~/.vim ~/.config
ln -sfn ~/.vim ~/.config/nvim
ln -sfn ~/.vimrc ~/.config/nvim/init.vim

if [ -e "$HOME/.config/kitty" ]; then
  echo "Warning: ~/.config/kitty exists"
else
  ln -sfn "$DIR/kitty" "$HOME/.config/kitty"
fi

if [[ "$OSTYPE" == darwin* ]]; then
  $DIR/osx.sh
fi
