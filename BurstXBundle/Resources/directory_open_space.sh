#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/10/18.

PLOT_PATH=$1
AVAIL_SPACE=$(df -g | grep $PLOT_PATH | awk '{ print $4 }')
echo "$AVAIL_SPACE"
