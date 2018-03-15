#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/5/18.

cd ~/Library/Application\ Support/BurstXBundle/
if [ ! -d "./burstcoin" ]; then
    echo "0"
else
    echo "1"
fi
