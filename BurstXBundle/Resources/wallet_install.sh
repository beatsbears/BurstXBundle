#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/5/18.

cd ~/Library/Application\ Support/BurstXBundle/
curl -o ./burstcoin.zip -k -L https://github.com/PoC-Consortium/burstcoin/releases/download/$1/burstcoin-$1.zip
mkdir burstcoin
unzip burstcoin.zip -d burstcoin >/dev/null
rm burstcoin.zip

if [ $1 = "1.3.6cg" ]; then
    echo "nxt.dbUrl=jdbc:mariadb://localhost:3306/burstwallet_xb" >> ./burstcoin/burstcoin-$1/conf/nxt.properties
    echo "nxt.dbUsername=burst_user_xb" >> ./burstcoin/burstcoin-$1/conf/nxt.properties
    echo "nxt.dbPassword=MyV3ryL0ngBurstP@ssword1!" >> ./burstcoin/burstcoin-$1/conf/nxt.properties
    chmod +x ./burstcoin/burstcoin-$1/burst.sh
else
    echo "DB.Url=jdbc:mariadb://localhost:3306/burstwallet_xb" >> ./burstcoin/conf/brs.properties
    echo "DB.Username=burst_user_xb" >> ./burstcoin/conf/brs.properties
    echo "DB.Password=MyV3ryL0ngBurstP@ssword1!" >> ./burstcoin/conf/brs.properties
    chmod +x ./burstcoin/burst.sh
fi
