#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/10/18.

PLOT_PATH=$1
AVAIL_SPACE=$(df -kg $PLOT_PATH | awk 'NR>1 { print $4 }')
echo "$AVAIL_SPACE"
