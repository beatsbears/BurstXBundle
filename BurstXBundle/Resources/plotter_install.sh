#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/10/18.

#https://github.com/k06a/mjminer.git
curl -o ./mjminer.zip -k -L https://github.com/k06a/mjminer/archive/master.zip
mkdir mjminer
unzip mjminer.zip -d mjminer >/dev/null
rm mjminer.zip
if [ ! -d "./mjminer" ]; then
    echo "'https://github.com/k06a/mjminer.git/' not found or unreachable."
else
    mv mjminer/ mjminer-master/
    cd mjminer-master/mjminer-master/
    make AVX2=$1
    if [ ! "./plot" ]; then
        echo "mjminer compilation failed."
        exit 1
    fi
    echo "1"
fi
