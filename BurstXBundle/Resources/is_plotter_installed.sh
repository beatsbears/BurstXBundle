#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/10/18.

cd ~/Library/Application\ Support/BurstXBundle/
if [ ! -d "./mjminer-master" ]; then
    echo "0"
else
    echo "1"
fi
