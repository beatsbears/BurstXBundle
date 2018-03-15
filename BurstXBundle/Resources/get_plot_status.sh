#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/10/18.

cd ~/Library/Application\ Support/BurstXBundle/
LAST=$(tail -n 1 ./$1)
echo "$LAST"
