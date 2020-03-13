#!/bin/bash

function git_clone()
{
  if [ ! -e "$HOME/$2" ]; then
    echo "Cloning '$1'..."
    git clone "$1" "$HOME/$2"
  else
    echoerr "~/$2 already exists."
  fi
}

DIR="$( cd "$( dirname "$0" )" && pwd )"
mv ~/.screenrc ~/.screenrc.old
ln -s $DIR/screenrc ~/.screenrc
#mv ~/.vim ~/.vim.old
#ln -s $DIR/vimfiles ~/.vim
mv ~/.vimrc ~/.vimrc.old
ln -s $DIR/vimrc ~/.vimrc
ln -s $DIR/ycm_extra_conf.py ~/.ycm_extra_conf.py
mv ~/.tmux.conf ~/.tmux.conf.old
ln -s $DIR/tmux.conf ~/.tmux.conf
cp bashrc ~/.bashrc
#mv ~/.emacs.d ~/.emacs.d.old
#ln -s $DIR/emacs.d ~/.emacs.d
#mv ~/.emacs ~/.emacs.old
#ln -s $DIR/emacs ~/.emacs
mv ~/.zshrc ~/.zshrc.old
ln -s $DIR/zshrc ~/.zshrc
mv ~/.railsrc ~/.railsrc.old
ln -s $DIR/railsrc ~/.railsrc

mv ~/.gitignore_global ~/.gitignore_global.old
ln -s $DIR/gitignore_global ~/.gitignore_global
mv ~/.gitconfig ~/.gitconfig.old
ln -s $DIR/gitconfig ~/.gitconfig
chsh -s `which zsh`

mkdir ~/bin
cp $DIR/safe-reattach-to-user-namespace ~/bin
chmod +x ~/bin/safe-reattach-to-user-namespace

cp $DIR/mdh ~/bin
chmod +x ~/bin/mdh

if [[ -e /usr/local/bin/brew ]]; then
  brew bundle --file=$DIR/Brewfile
  $(brew --prefix)/opt/fzf/install
  if [[ "$OSTYPE" == darwin* ]]; then
    for cask in $(brew cask list); do
      APP="$(brew cask info "$cask" |
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
  # turn off long press latin characters
  defaults write -g ApplePressAndHoldEnabled -bool false
  # turn off antialiasing for terminal.app
  defaults write com.apple.Terminal AppleFontSmoothing -int 0
  # gureum config
  defaults write org.youknowone.inputmethod.Gureum CIMRomanModeByEscapeKey YES
  # set shortcut for gureum to cmd + space
  defaults write org.youknowone.inputmethod.Gureum CIMInputModeExchangeKeyModifier 1048576
fi
