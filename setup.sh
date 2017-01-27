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
mv ~/.tmux.conf ~/.tmux.conf.old
ln -s $DIR/tmux.conf ~/.tmux.conf
cp bashrc ~/.bashrc
#mv ~/.emacs.d ~/.emacs.d.old
#ln -s $DIR/emacs.d ~/.emacs.d
#mv ~/.emacs ~/.emacs.old
#ln -s $DIR/emacs ~/.emacs
mv ~/.zshrc ~/.zshrc.old
ln -s $DIR/zshrc ~/.zshrc
git_clone https://github.com/zplug/zplug.git .zplug/repos/zplug/zplug
ln -s "$HOME/.zplug/repos/zplug/zplug/init.zsh" "$HOME/.zplug/init.zsh"
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
  cat brewlist | xargs brew install
fi

# neovim
mkdir ~/.config
ln -s ~/.vim ~/.config/nvim
ln -s ~/.vimrc ~/.config/nvim/init.vim
