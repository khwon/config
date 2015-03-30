# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
#ZSH_THEME="random"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
 DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
 COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git brew extract gem)
plugins+=(autojump bundler encode64 nyan urltools web-search)
#temporary disable due to conflict with autojump
#plugins+=(common-aliases)
if [[ -e /etc/zsh_command_not_found ]]; then
  plugins+=(command-not-found)
fi

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
	export PATH=/usr/local/bin:$PATH
  if [[ -e /usr/local/opt/coreutils/libexec/gnubin ]]; then
    PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
  fi
  plugins+=(forklift osx)
fi


source $ZSH/oh-my-zsh.sh
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

PROMPT=$'%{\e[01;32m%}%n@%m%{\e[00m%}:%{\e[01;34m%}%5c%{\e[00m%}\$ '
#TERM="screen-256color"

if [[ -e $HOME/.rvm ]]; then
  PATH=$HOME/.rvm/bin:$PATH # Add RVM to PATH for scripting
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi
PATH=$HOME/bin:$PATH
if [[ -e $HOME/.rbenv ]]; then
  PATH=$HOME/.rbenv/bin:$PATH
  eval "$(rbenv init -)"
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export WORKON_HOME=~/.virtualenvs
if [[ -e /usr/local/bin/virtualenvwrapper.sh ]]; then
  source /usr/local/bin/virtualenvwrapper.sh
fi
function gi() { curl https://www.gitignore.io/api/$@ ;}
