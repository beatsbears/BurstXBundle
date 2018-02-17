#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/5/18.

curl --silent "https://api.github.com/repos/PoC-Consortium/burstcoin/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
