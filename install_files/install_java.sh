#!/bin/bash

set -e # exit on error

# check if paths are provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <install_dir>"
    echo "       install_dir: directory to install Java to"
    exit 1
fi

INSTALL_PATH=$1
# check if java is already installed by checking if Java directory exists and is not empty
if [ -d "$INSTALL_PATH" ] && [ "$(ls -A $INSTALL_PATH)" ]; then
    echo "Detected existing Java installation in $INSTALL_PATH, skipping installation."
    exit 0
fi

mkdir -p $INSTALL_PATH
ARCHIVE_PATH=${TMPDIR:-/tmp}/jdk-23_linux-x64_bin.tar.gz
wget -O $ARCHIVE_PATH https://download.oracle.com/java/23/latest/jdk-23_linux-x64_bin.tar.gz
tar -xzf $ARCHIVE_PATH -C $INSTALL_PATH
rm $ARCHIVE_PATH
