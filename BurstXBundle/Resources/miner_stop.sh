#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/26/18.

kill $(ps aux | grep 'creepMiner' | awk '{print $2}')
