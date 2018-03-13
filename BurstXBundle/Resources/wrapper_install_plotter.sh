#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 3/12/18.

VAR=${BASH_SOURCE%/*}
DIR=$(dirname "${VAR}")
osascript -e "do shell script \"$DIR/Resources/plotter_install.sh\" with administrator privileges"
