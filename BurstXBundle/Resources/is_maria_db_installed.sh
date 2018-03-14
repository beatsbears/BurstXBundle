#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/5/18.



if [ ! -d "/usr/local/mariadb" ]; then
    which -s brew
    if [[ $? != 0 ]] ; then
        # MariaDB isn't in the default location and brew isn't installed
        echo "0"
    else
        if brew ls --versions mariadb > /dev/null; then
        # MariaDB isn't in the default location, brew is installed, and brew returns a version of MariaDB is installed
            echo "1"
        else
            # MariaDB isn't in the default location, brew is installed, and there is no known version of MariaDB
            echo "0"
        fi
    fi
else
    # MariaDB exists in the default location
    echo "1"
fi
