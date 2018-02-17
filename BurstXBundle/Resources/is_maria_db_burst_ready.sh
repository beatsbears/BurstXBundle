#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/5/18.

if /usr/local/mariadb/server/bin/mariadb -u burstwallet -pPASSWORD -h localhost -e "\q" ; then
    echo "1"
else
    echo "0"
fi
