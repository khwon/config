typeset -aU path
function add_to_path_once()
{
  path=($1 $path)
}
# set LS_COLORS
export LS_COLORS="di=1;34:ln=1;35:so=1;32:pi=1;33:ex=1;31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
  add_to_path_once "/usr/local/bin"
  if [[ -e /usr/local/opt/coreutils/libexec/gnubin ]]; then
    add_to_path_once "/usr/local/opt/coreutils/libexec/gnubin"
    alias ls='ls --color=auto'
    export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
  fi
  if [[ -e /usr/local/opt/ruby/bin ]]; then
    add_to_path_once "/usr/local/opt/ruby/bin"
  fi
fi

if [[ "$OSTYPE" == linux* ]]; then
  alias ls='ls --color=auto'
  if [[ -e $HOME/.linuxbrew/bin ]]; then
    add_to_path_once "$HOME/.linuxbrew/bin"
  fi
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

# add custom completions
fpath=(~/.config/zsh $fpath)

source ~/.config/zsh/config.zsh
source ~/.config/zsh/plugins.zsh
source ~/.config/zsh/bundler.plugin.zsh
# TODO : debug slow startup
#source ~/.config/zsh/command-not-found.plugin.zsh
source ~/.config/zsh/extract.plugin.zsh
source ~/.config/zsh/encode64.plugin.zsh
source ~/.config/zsh/termsupport.zsh


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
bindkey '^P' fzf-history-widget

source <(antibody init)

antibody bundle <<EOF
khwon/lime
rimraf/k
zsh-users/zsh-completions
EOF
antibody bundle zsh-users/zsh-syntax-highlighting

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
