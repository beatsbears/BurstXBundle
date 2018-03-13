#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/5/18.

if /usr/local/mariadb/server/bin/mariadb -u burst_user_xb -pMyV3ryL0ngBurstP@ssword1! -h localhost -e "\q" ; then
    echo "1"
else
    echo "0"
fi
