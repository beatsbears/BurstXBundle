#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/10/18.

git clone https://github.com/k06a/mjminer.git
mv mjminer/ mjminer-master/
cd mjminer-master/
make AVX2=$1
