# Set terminal window and tab/icon title
#
# usage: title short_tab_title [long_window_title]
#
# See: http://www.faqs.org/docs/Linux-mini/Xterm-Title.html#ss3.1
# Fully supports screen, iterm, and probably most modern xterm and rxvt
# (In screen, only short_tab_title is used)
# Limited support for Apple Terminal (Terminal can't set window and tab separately)
function title {
  emulate -L zsh
  setopt prompt_subst

  [[ "$EMACS" == *term* ]] && return

  # if $2 is unset use $1 as default
  # if it is set and empty, leave it as is
  : ${2=$1}

  case "$TERM" in
    cygwin|xterm*|putty*|rxvt*|ansi)
      print -Pn "\e]2;$2:q\a" # set window name
      print -Pn "\e]1;$1:q\a" # set tab name
      ;;
    screen*)
      # set the tab window title (%t) for screen
      print -Pn $'\033k'$1$'\033'\\\

      # set hardstatus of tab window (%h) for screen
      print -Pn $'\033]0;'$2$'\a'
      ;;
    *)
      if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
        print -Pn "\e]2;$2:q\a" # set window name
        print -Pn "\e]1;$1:q\a" # set tab name
      else
        # Try to use terminfo to set the title
        # If the feature is available set title
        if [[ -n "$terminfo[fsl]" ]] && [[ -n "$terminfo[tsl]" ]]; then
          echoti tsl
          print -Pn "$1"
          echoti fsl
        fi
      fi
      ;;
  esac
}

if [[ $_GET_PATH == '' ]]; then
  _GET_PATH='echo $PWD | sed "s/^\\\/Users\\\//~/;s/^\\\/home\\\//~/;s/^~$USER/~/"'
fi

# use the current user as the prefix of the current tab title
TITLE_PATH='`'$_GET_PATH' | sed "s:..*/::"`$PROMPT_CHAR'
# when at the shell prompt, show a truncated version of the current path (with
# standard ~ replacement) as the rest of the title.
TITLE_PROMPT='$SHELL:t'
# when running a command, show the title of the command as the rest of the
# title (truncate to drop the path to the command)
TITLE_EXEC='$cmd[1]:t'

TAB_HARDSTATUS="%m(%n): %~"

# Runs before showing the prompt
function termsupport_precmd {
  emulate -L zsh
  title $TITLE_PATH $TAB_HARDSTATUS
}

# Runs before executing the command
function termsupport_preexec {
  emulate -L zsh
  setopt extended_glob
  local -a cmd; cmd=(${(z)1}) # the command string
  title $TITLE_EXEC:$TITLE_PATH $TAB_HARDSTATUS
}

precmd_functions+=(termsupport_precmd)
preexec_functions+=(termsupport_preexec)


