#!/bin/bash

set -e # exit on error

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
INSTALL_PATH=$(realpath $SCRIPT_DIR/java)

mkdir -p $INSTALL_PATH
ARCHIVE_PATH=${TMPDIR:-/tmp}/jdk-22_linux-x64_bin.tar.gz
wget -O $ARCHIVE_PATH https://download.oracle.com/java/22/latest/jdk-22_linux-x64_bin.tar.gz
tar -xzf $ARCHIVE_PATH -C $INSTALL_PATH
rm $ARCHIVE_PATH
