#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/10/18.

TOTAL_MEM=$(system_profiler SPHardwareDataType | grep "  Memory:" | awk '{ print $2 }')
echo "$TOTAL_MEM"
