#!/bin/zsh

###
### zsh config
###

# history
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=$HOME/.zsh_history

# zsh options
autoload -U bashcompinit
autoload -U compinit

bashcompinit -u
compinit -u

setopt ALWAYS_TO_END
setopt AUTO_LIST
setopt AUTO_PUSHD
setopt BANG_HIST
setopt EXTENDED_GLOB
setopt EXTENDED_HISTORY
setopt NO_FLOW_CONTROL
setopt GLOB_DOTS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt IGNORE_EOF
setopt INTERACTIVE_COMMENTS
setopt LIST_PACKED
setopt LIST_TYPES
setopt LONG_LIST_JOBS
setopt MAGIC_EQUAL_SUBST
setopt NOTIFY
setopt NUMERIC_GLOB_SORT
setopt PRINT_EIGHT_BIT
setopt PROMPT_SUBST
setopt PUSHD_IGNORE_DUPS
setopt SHARE_HISTORY

unsetopt BG_NICE

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}


# prompt
if [ `hostname | grep -i -e '.local$'` ]; then
    PROMPT="%n@%m%# "
else
    PROMPT="%n@%{[31m%}%m%{[m%}%# "
fi

RPROMPT="[%~]"


###
### common environment config
###

read_config () {
    if [ "x$MY_CONFIG_ROOT" != "x" ]; then
        # for development
        my_dir=$MY_CONFIG_ROOT/shell
    else
        my_dir=$($HOME/local/bin/abspath $(dirname $0))
    fi

    if [ -f "$my_dir/$1" ]; then
        cat "$my_dir/$1"
    fi
}

add_config () {
    read_config "$1" | source /dev/stdin
}

check_command_existance () {
    which $1 >/dev/null 2>/dev/null
    return $!
}

add_command_completions () {
    [ -d $1 ] && source $1/^.* 2>/dev/null
}

add_to_path () {
    if [ -d $1 ]; then
        export PATH=$1:$PATH
    fi
}

# add ~/local/{bin,sbin} to PATH
add_to_path $HOME/local/bin


# set EDITOR variable
check_command_existance emacs && EDITOR=emacs || EDITOR=vi
export EDITOR


# add useful shell command aliases & functions
alias grep='grep --color=auto'

mkcd() { mkdir -p "$@" && cd "$_"; }


# Python-related settings
export PYTHONPATH=$HOME/local/lib/python:$PYTHONPATH
export PYTHONSTARTUP=$HOME/local/lib/python/startup.py

workon() { source $HOME/local/env/python/$1/bin/activate; }


###
### Mac OS X specific settings
###

if [ -d "/Volumes" ]; then
    # settings for homebrew
    export HOMEBREW_PREFIX=/opt/homebrew
    add_to_path $HOMEBREW_PREFIX/bin
    add_to_path $HOMEBREW_PREFIX/sbin
    add_to_path $HOMEBREW_PREFIX/share/git-core/contrib/diff-highlight
    add_to_path $HOMEBREW_PREFIX/opt/ruby/bin

    export HOMEBREW_CASK_OPTS=--appdir=/Applications
    export HOMEBREW_GITHUB_API_TOKEN=$(read_config homebrew-github-api-token.txt)

    add_command_completions $HOMEBREW_PREFIX/etc/bash_completion.d
    add_command_completions $HOMEBREW_PREFIX/share/zsh/site-functions

    # useful aliases and functions
    alias ls="ls -Gw"
    check_command_existance rmtrash && alias rm="rmtrash"
fi


###
### Linux specific settings
###

if [ -d "/proc" ]; then
    # HGC
    if [ `hostname | grep -e "\(gw[0-9]\+\)\|\(c[0-9]\+\)\|\(cl[0-9]\+\)"` ]; then
        # terminal (for qlogin)
        export TERM=xterm
    fi
fi
