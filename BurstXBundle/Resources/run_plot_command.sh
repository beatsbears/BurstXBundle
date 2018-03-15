#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/10/18.

cd ~/Library/Application\ Support/BurstXBundle/
DIR=$(pwd)
osascript -e "do shell script \"$DIR/tmp_plot_command.sh\" with administrator privileges" > log.this.too
LS_FILES=$(ls -la)
echo "$DIR"
