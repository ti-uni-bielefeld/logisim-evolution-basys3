#!/bin/bash

set -e # exit on error

# check if at least one argument and at most two arguments are provided
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: $0 <install_dir> [vivado_installer]"
    echo "       install_dir: Xilinx directory to install Vivado to"
    echo "       vivado_installer: \"Linux Self Extracting Web Installer\" downloaded from https://www.xilinx.com/support/download.html"
    echo "                         This is optional if Vivado is already installed"
    exit 1
fi

INSTALL_PATH=$(realpath $1)

# check if vivado is already installed by checking if Vivado directory exists and is not empty
if [ -d "$INSTALL_PATH" ] && [ "$(ls -A $INSTALL_PATH)" ]; then
    echo "Detected existing Vivado installation in $INSTALL_PATH, skipping installation."
    exit 0
fi

# check if vivado installer is provided
if [ "$#" -ne 2 ]; then
    echo "Vivado installer not provided. Please download \"Linux Self Extracting Web Installer\" from https://www.xilinx.com/support/download.html"
    exit 1
fi

VIVADO_INSTALLER=$(realpath $2)

# check if installer exists
if [ ! -f "$VIVADO_INSTALLER" ]; then
    echo "File not found: $VIVADO_INSTALLER"
    exit 1
fi

# make directory if it doesn't exist
mkdir -p $INSTALL_PATH

# set install path in config file
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
sed -i 's#^Destination=.*$#Destination='"$INSTALL_PATH"'#g' $SCRIPT_DIR/vivado_install_config.txt

# make installer executable
chmod +x $VIVADO_INSTALLER

$VIVADO_INSTALLER -- -b AuthTokenGen
$VIVADO_INSTALLER -- -b Install -a XilinxEULA,3rdPartyEULA -c $SCRIPT_DIR/vivado_install_config.txt
