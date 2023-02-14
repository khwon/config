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

add_to_path_once()
{
  if [ -d $1 ]; then
    path=($1 $path)
  fi
}

source_if_exists()
{
  if [[ -r $1 ]]; then
    source $1
    return 0
  else
    return 1
  fi
}

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
source_if_exists "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

# set LS_COLORS
export LS_COLORS="di=1;34:ln=1;35:so=1;32:pi=1;33:ex=1;31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
  export DISPLAY=:0
  add_to_path_once "/usr/local/bin"
  # alternative homebrew installation path
  if [[ -e /usr/local/homebrew/bin && ! -e /usr/local/bin/brew ]]; then
    add_to_path_once "/usr/local/homebrew/bin"
  fi
  if [[ -e /opt/homebrew/bin ]]; then
    add_to_path_once "/opt/homebrew/bin"
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
  source_if_exists "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi

# Set PATH to include user's bin if it exists
add_to_path_once "$HOME/bin"

if [[ -e $HOME/.rbenv ]]; then
  add_to_path_once "$HOME/.rbenv/bin"
  eval "$(rbenv init -)"
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export WORKON_HOME=~/.virtualenvs
source_if_exists /usr/local/bin/virtualenvwrapper.sh

function gi() { curl https://www.gitignore.io/api/$@ ;}

source_if_exists $HOME/.zshrc_local

# configure thefuck
if [[ -e /usr/local/bin/fuck ]]; then
  # eval $(thefuck --alias)
  # dirty hack for startup time
  alias fuck='TF_CMD=$(TF_ALIAS=fuck PYTHONIOENCODING=utf-8 TF_SHELL_ALIASES=$(alias) thefuck $(fc -ln -1 | tail -n 1)) && eval $TF_CMD ; test -n "$TF_CMD" && print -s $TF_CMD'
fi

# orders for finding in manpages
MANSECT="2:3:3p:1:1p:8:4:5:6:7:9:0p:tcl:n:l:p:o"
export MANSECT

# Use zinit
if [ -e "$BREW_PREFIX/opt/zinit/" ]; then
  source "$BREW_PREFIX/opt/zinit/zinit.zsh"
elif [ -e "$HOME/.zinit/bin/" ]; then
  source "$HOME/.zinit/bin/zinit.zsh"
else
  ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
  if ! [ -e "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
  fi
  source "${ZINIT_HOME}/zinit.zsh"
fi

# Additional completion definitions for Zsh
if is-at-least 5.3; then
  zinit ice lucid wait'0' blockf
else
  zinit ice blockf
fi
zinit light zsh-users/zsh-completions

# A lightweight start point of shell configuration
zinit light yous/vanilli.sh

#zinit light khwon/lime
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light rimraf/k

# Syntax-highlighting for Zshell – fine granularity, number of features, 40 work
# hours themes (short name F-Sy-H)
if is-at-least 5.3; then
  zinit ice lucid wait'0' atinit'zpcompinit; zpcdreplay'
else
  autoload -Uz compinit
  compinit
  zinit cdreplay -q
fi
zinit light zdharma/fast-syntax-highlighting

zinit ice svn
zinit snippet OMZ::plugins/extract
zinit snippet OMZ::lib/termsupport.zsh

# Load autojump
autojump_locations=(
  "$HOME/.autojump/etc/profile.d/autojump.sh"
  "/etc/profile.d/autojump.zsh"
  "/usr/share/autojump/autojump.zsh"
)
if [ -n "$BREW_PREFIX" ]; then
  autojump_locations=($autojump_locations "$BREW_PREFIX/etc/autojump.sh")
fi
for loc in $autojump_locations; do
  if source_if_exists $loc; then
    break
  fi
done

if ! source_if_exists ~/.fzf.zsh; then
  source_if_exists /usr/share/doc/fzf/examples/completion.zsh
  source_if_exists /usr/share/doc/fzf/examples/key-bindings.zsh
fi
bindkey '^P' fzf-history-widget

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source_if_exists ~/.p10k.zsh

# Unset local functions and variables
unset BREW_PREFIX
unset BREW_OPT_PREFIX
unset -f add_to_path_once
unset -f source_if_exists
