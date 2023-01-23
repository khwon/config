#!/bin/bash

function install_rc()
{
  echo "installing '$1'.."
  if [ -e "$HOME/.$1" ]; then
    mv "$HOME/.$1" "$HOME/.$1.old"
  fi
  ln -s "$DIR/$1" "$HOME/.$1"
}

DIR="$( cd "$( dirname "$0" )" && pwd )"
install_rc screenrc
install_rc vimrc
install_rc ycm_extra_conf.py
install_rc tmux.conf
install_rc bashrc
install_rc zshrc
install_rc p10k.zsh
install_rc railsrc

install_rc gitignore_global
install_rc gitconfig

chsh -s `which zsh`

mkdir ~/bin
cp $DIR/safe-reattach-to-user-namespace ~/bin
chmod +x ~/bin/safe-reattach-to-user-namespace

cp $DIR/mdh ~/bin
chmod +x ~/bin/mdh

BREW=""
if [[ -e /usr/local/bin/brew ]]; then
  BREW="/usr/local/bin/brew"
fi
if [[ -e /opt/homebrew/bin/brew ]]; then
  BREW="/opt/homebrew/bin/brew"
fi

if [[ -e $BREW ]]; then
  $BREW bundle --file=$DIR/Brewfile
  $($BREW --prefix)/opt/fzf/install
  if [[ "$OSTYPE" == darwin* ]]; then
    for cask in $($BREW cask list); do
      APP="$($BREW cask info "$cask" |
        awk '/.* \(App\)/ { sub(" \\(App\\)",""); print  }')"
      if [[ ! -z "$APP" ]]; then
        sudo xattr -dr "/Applications/$APP"
      fi
    done
  fi
fi

# neovim
mkdir ~/.config
ln -s ~/.vim ~/.config/nvim
ln -s ~/.vimrc ~/.config/nvim/init.vim

mkdir ~/.config/thefuck
ln -s $DIR/thefuck/settings.py ~/.config/thefuck/settings.py

if [[ "$OSTYPE" == darwin* ]]; then
  $DIR/osx.sh
fi
