#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/10/18.

DIR=$(pwd)
osascript -e "do shell script \"$DIR/tmp_plot_command.sh\" with administrator privileges"
LS_FILES=$(ls -la)
echo "$LS_FILES"
