#!/bin/sh

#
link_file () {
    echo "Linking file:"
    echo "  source:      $1"
    echo "  destination: $2"

    if [ ! -f $2 ]; then
        ln -s $1 $2
    else
        echo "  file exists: $1" >&2
    fi
}

create_directory () {
    if [ ! -d $1 ]; then
        echo "Creating a directory:"
        echo "  target:      $1"
        mkdir -p $1
    fi

    if [ x"$2" != "x" ]; then
        echo "Setting permission of a directory:"
        echo "  target:      $1"
        echo "  mode:        $2"
        chmod $2 $1
    fi
}


# links files
cd $(dirname $0)
MY_DIR=$(pwd)

## screen
link_file $MY_DIR/screen/screenrc $HOME/.screenrc

## shell
link_file $MY_DIR/shell/zshrc.zsh $HOME/.zshrc

## ssh
create_directory $HOME/.ssh 700
link_file $MY_DIR/ssh/config $HOME/.ssh/config

## vcs
link_file $MY_DIR/vcs/gitconfig.ini $HOME/.gitconfig
link_file $MY_DIR/vcs/hgrc.ini $HOME/.hgrc
