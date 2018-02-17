#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/5/18.

/usr/local/mariadb/server/bin/mariadb -u root -h localhost << END
CREATE DATABASE IF NOT EXISTS burstwallet;
CREATE USER 'burstwallet'@'localhost' IDENTIFIED BY 'PASSWORD';
GRANT ALL PRIVILEGES ON burstwallet.* TO 'burstwallet'@'localhost';
END
