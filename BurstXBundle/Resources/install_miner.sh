#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/19/18.

# check if brew is installed
#if ! type "brew" > /dev/null; then
    #brew is not installed
#    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#fi

# install poco
#brew install poco

# install openssl dev headers
#brew install openssl
#ln -s /usr/local/opt/openssl/include/openssl /usr/local/include/openssl

# install cmake
#brew install cmake

## install conan
#brew install conan

# get creepMiner
#LASTEST_VER=$(curl --silent "https://api.github.com/repos/Creepsky/creepMiner/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
#curl -o ./creep.zip -k -L https://github.com/Creepsky/creepMiner/releases/download/1.7.13.zip
#mkdir creepMiner
#unzip creep.zip -d creepMiner >/dev/null
#rm creep.zip

# compile creepMiner
#cd creepMiner/creepMiner-1.7.13
#conan install . --build=missing -s compiler.libcxx=libstdc++
#cmake CMakeLists.txt -DCMAKE_BUILD_TYPE=RELEASE -DNO_GPU=ON
#make
VAR=${BASH_SOURCE%/*}
DIR=$(dirname "${VAR}")
WORK_DIR=$(pwd)

if [ ! -d "./creepMiner" ]; then
    mv $DIR/Resources/creepMiner $WORK_DIR
    if [ ! -d "./creepMiner" ]; then
        echo "1"
    else
        echo "0"
    fi
else
    echo "1"
fi

