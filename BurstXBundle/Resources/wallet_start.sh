#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/5/18.

cd ~/Library/Application\ Support/BurstXBundle/
if [ $1 = "1.3.6cg" ]; then
    cd ./burstcoin/burstcoin-$1/
else
    cd ./burstcoin/
fi
./burst.sh >/dev/null 2>&1 &
echo $! > wallet.pid
