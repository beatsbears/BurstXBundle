#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/26/18.

VAR=${BASH_SOURCE%/*}
DIR=$(dirname "${VAR}")

sh $DIR/Resources/creepMiner/bin/run.sh >/dev/null 2>&1 &
