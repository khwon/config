typeset -aU path

bundle_install() {
  local cores_num
  if [ "$(uname)" = 'Darwin' ]; then
    cores_num="$(sysctl -n hw.ncpu)"
  else
    cores_num="$(nproc)"
  fi
  bundle install --jobs="$cores_num" "$@"
}

function add_to_path_once()
{
  path=($1 $path)
}
# set LS_COLORS
export LS_COLORS="di=1;34:ln=1;35:so=1;32:pi=1;33:ex=1;31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
  export DISPLAY=:0
  add_to_path_once "/usr/local/bin"
  # alternative hombrew installation path
  if [[ -e /usr/local/homebrew/bin ]]; then
    add_to_path_once "/usr/local/homebrew/bin"
  fi
  export CLICOLOR=1
  export LSCOLORS="ExFxCxDxBxegedabagacad"
fi

if [[ "$OSTYPE" == linux* ]]; then
  alias ls='ls --color=auto'
  if [[ -e $HOME/.linuxbrew/bin ]]; then
    eval $($HOME/.linuxbrew/bin/brew shellenv)
  fi
  if [[ -e /home/linuxbrew/.linuxbrew ]]; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  fi
fi

#brew settings
if command -v brew >/dev/null; then
  BREW_PREFIX="$(brew --prefix)"
  if [[ -e $BREW_PREFIX/opt ]]; then
    BREW_OPT_PREFIX=$BREW_PREFIX/opt
  else
    BREW_OPT_PREFIX="/usr/local/opt"
  fi
  if [[ -e $BREW_OPT_PREFIX/coreutils/libexec/gnubin ]]; then
    add_to_path_once "$BREW_OPT_PREFIX/coreutils/libexec/gnubin"
    alias ls='ls --color=auto'
    export MANPATH="$BREW_OPT_PREFIX/coreutils/libexec/gnuman:$MANPATH"
  else
  fi
  if [[ -e $BREW_OPT_PREFIX/ruby/bin ]]; then
    add_to_path_once "$BREW_OPT_PREFIX/ruby/bin"
  fi
  add_to_path_once $(gem environment | grep "EXECUTABLE DIRECTORY" | awk '{print $NF}')
fi

if [[ -e $HOME/.rvm ]]; then
  # Add RVM to PATH for scripting
  add_to_path_once "$HOME/.rvm/bin"
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi

# Set PATH to include user's bin if it exists
if [ -d "$HOME/bin" ]; then
  add_to_path_once "$HOME/bin"
fi

if [[ -e $HOME/.rbenv ]]; then
  add_to_path_once "$HOME/.rbenv/bin"
  eval "$(rbenv init -)"
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export WORKON_HOME=~/.virtualenvs
if [[ -e /usr/local/bin/virtualenvwrapper.sh ]]; then
  source /usr/local/bin/virtualenvwrapper.sh
fi
function gi() { curl https://www.gitignore.io/api/$@ ;}

if [[ -e $HOME/.zshrc_local ]]; then
  source $HOME/.zshrc_local
fi

# configure thefuck
if [[ -e /usr/local/bin/fuck ]]; then
  # eval $(thefuck --alias)
  # dirty hack for startup time
  alias fuck='TF_CMD=$(TF_ALIAS=fuck PYTHONIOENCODING=utf-8 TF_SHELL_ALIASES=$(alias) thefuck $(fc -ln -1 | tail -n 1)) && eval $TF_CMD ; test -n "$TF_CMD" && print -s $TF_CMD'
fi

# orders for finding in manpages
MANSECT="2:3:3p:1:1p:8:4:5:6:7:9:0p:tcl:n:l:p:o"
export MANSECT

# Unset local functions
unset -f add_to_path_once

# Use Zplugin
if [ ! -e "$HOME/.zinit/bin/zinit.zsh" ]; then
  mkdir ~/.zinit
  git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
fi
source "$HOME/.zinit/bin/zinit.zsh"

# Additional completion definitions for Zsh
if is-at-least 5.3; then
  zplugin ice lucid wait'0' blockf
else
  zplugin ice blockf
fi
zplugin light zsh-users/zsh-completions

# A lightweight start point of shell configuration
zplugin light yous/vanilli.sh

zplugin light khwon/lime
zplugin light rimraf/k

# Syntax-highlighting for Zshell – fine granularity, number of features, 40 work
# hours themes (short name F-Sy-H)
if is-at-least 5.3; then
  zplugin ice lucid wait'0' atinit'zpcompinit; zpcdreplay'
else
  autoload -Uz compinit
  compinit
  zplugin cdreplay -q
fi
zplugin light zdharma/fast-syntax-highlighting

zplugin ice svn
zplugin snippet OMZ::plugins/extract
zplugin snippet OMZ::lib/termsupport.zsh

# Load autojump
if command -v autojump >/dev/null; then
  if [ -f "$HOME/.autojump/etc/profile.d/autojump.sh" ]; then
    source "$HOME/.autojump/etc/profile.d/autojump.sh"
  elif [ -f /etc/profile.d/autojump.zsh ]; then
    source /etc/profile.d/autojump.zsh
  elif [ -f /usr/share/autojump/autojump.zsh ]; then
    source /usr/share/autojump/autojump.zsh
  elif [ -n "$BREW_PREFIX" ]; then
    if [ -f "$BREW_PREFIX/etc/autojump.sh" ]; then
      source "$BREW_PREFIX/etc/autojump.sh"
    fi
  fi
elif [ -f "$HOME/.autojump/etc/profile.d/autojump.sh" ]; then
  source "$HOME/.autojump/etc/profile.d/autojump.sh"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
bindkey '^P' fzf-history-widget

# Unset local functions and variables
unset BREW_PREFIX
unset BREW_OPT_PREFIX

# git aliases
alias gco='git checkout'
alias gl='git pull'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias gp='git push'
# ls aliases
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

#update DISPLAY env variable
update_display() {
  #update only in screen or tmux
  if [ -n "$STY" -o -n "$TMUX" ]; then
    export DISPLAY="`tmux show-env | sed -n 's/^DISPLAY=//p'`"
  fi
}
