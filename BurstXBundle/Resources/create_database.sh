#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/5/18.

/usr/local/mariadb/server/bin/mariadb -u root -h localhost << END
CREATE DATABASE IF NOT EXISTS burstwallet_xb;
CREATE USER 'burst_user_xb'@'localhost' IDENTIFIED BY 'MyV3ryL0ngBurstP@ssword1!';
GRANT ALL PRIVILEGES ON burstwallet_xb.* TO 'burst_user_xb'@'localhost';
END
