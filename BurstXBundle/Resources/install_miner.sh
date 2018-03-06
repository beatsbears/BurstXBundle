#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/19/18.

VAR=${BASH_SOURCE%/*}
DIR=$(dirname "${VAR}")
WORK_DIR=$(pwd)

if [ ! -d "./creepMiner" ]; then
    cp -r $DIR/Resources/creepMiner $WORK_DIR
    cd $WORK_DIR
    if [ -d "./creepMiner" ]; then
        echo "1"
    else
        LISTED_FILES=$(ls -la)
        echo "$LISTED_FILES"
    fi
else
    echo "1"
fi

