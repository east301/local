#!/bin/sh

#
cd $(dirname $0)
MY_DIR=$(pwd)


# installs homebrew packages
brew bundle $MY_DIR/homebrew/brewfile
