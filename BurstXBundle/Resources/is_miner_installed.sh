#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/19/18.

VAR=${BASH_SOURCE%/*}
DIR=$(dirname "${VAR}")
cd $DIR/Resources
if [ ! -d "./creepMiner" ]; then
    LISTED=$(ls -la)
    echo "$LISTED"
else
    echo "1"
fi
