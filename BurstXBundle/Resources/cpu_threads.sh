#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/10/18.

TOTAL_THREADS=$(sysctl -n hw.ncpu)
echo "$TOTAL_THREADS"
