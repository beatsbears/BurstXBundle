#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/5/18.

VAR=${BASH_SOURCE%/*}
DIR=$(dirname "${VAR}")
osascript -e "do shell script \"$DIR/Resources/isMariaDBBurstReady.sh\" with administrator privileges"
