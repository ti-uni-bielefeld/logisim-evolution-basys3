#!/bin/bash

set -e # exit on error

# check if paths are provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <vivado_installer>"
    echo "       vivado_installer: \"Linux Self Extracting Web Installer\" downloaded from https://www.xilinx.com/support/download.html"
    exit 1
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
VIVADO_INSTALLER=$(realpath $1)
INSTALL_PATH=$(realpath $SCRIPT_DIR/Xilinx)

# check if installer exists
if [ ! -f "$VIVADO_INSTALLER" ]; then
    echo "File not found: $VIVADO_INSTALLER"
    exit 1
fi

# make directory if it doesn't exist
mkdir -p $INSTALL_PATH

# set install path in config file
sed -i 's#^Destination=.*$#Destination='"$INSTALL_PATH"'#g' $SCRIPT_DIR/vivado_install_config.txt

# make installer executable
chmod +x $VIVADO_INSTALLER

$VIVADO_INSTALLER -- -b AuthTokenGen
$VIVADO_INSTALLER -- -b Install -a XilinxEULA,3rdPartyEULA -c $SCRIPT_DIR/vivado_install_config.txt
