#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/5/18.

cd ~/Library/Application\ Support/BurstXBundle/
cd ./burstcoin/burstcoin-$1/
./burst.sh >/dev/null 2>&1 &
echo $! > wallet.pid
