#!/bin/bash
DIR="$( cd "$( dirname "$0" )" && pwd )"
echo "set-option -g default-command \"$DIR/reattach-to-user-namespace -l zsh\"" >> tmux.conf
