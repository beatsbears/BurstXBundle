#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/5/18.

curl -o ./burstcoin.zip -k -L https://github.com/PoC-Consortium/burstcoin/releases/download/$1/burstcoin-$1.zip
mkdir burstcoin
unzip burstcoin.zip -d burstcoin >/dev/null
rm burstcoin.zip

if [ $1 = "1.3.6cg" ]; then
    echo "nxt.dbUrl=jdbc:mariadb://localhost:3306/burstwallet" >> ./burstcoin/burstcoin-$1/conf/nxt.properties
    echo "nxt.dbUsername=burstwallet" >> ./burstcoin/burstcoin-$1/conf/nxt.properties
    echo "nxt.dbPassword=PASSWORD" >> ./burstcoin/burstcoin-$1/conf/nxt.properties
else
    echo "Unknown Version"
fi

chmod +x ./burstcoin/burstcoin-$1/burst.sh
