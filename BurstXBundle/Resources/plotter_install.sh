#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/10/18.

git clone https://github.com/k06a/mjminer.git
if [ ! -d "./mjminer" ]; then
    echo "'https://github.com/k06a/mjminer.git1/' not found or unreachable."
else
    mv mjminer/ mjminer-master/
    cd mjminer-master/
    make AVX2=$1
    if [ ! "./mjminer-master/plot" ]; then
        echo "mjminer compilation failed."
    fi
    echo "1"
fi
