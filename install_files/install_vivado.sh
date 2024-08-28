#!/bin/bash

set -e # exit on error

# check if at least one argument and at most two arguments are provided
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: $0 <install_dir> [vivado_installer]"
    echo "       install_dir: Xilinx directory to install Vivado to"
    echo "       vivado_installer: Vivado 2023.2 installer downloaded from https://www.xilinx.com/member/forms/download/xef.html?filename=FPGAs_AdaptiveSoCs_Unified_2023.2_1013_2256_Lin64.bin"
    echo "                         This is optional if Vivado is already installed"
    exit 1
fi

INSTALL_PATH=$1
VIVADO_2023_2_PATH=$INSTALL_PATH/Vivado/2023.2

# check if vivado is already installed by checking if Vivado directory exists and is not empty
if [ -d "$VIVADO_2023_2_PATH" ] && [ "$(ls -A $VIVADO_2023_2_PATH)" ]; then
    echo "Detected existing Vivado 2023.2 installation in $INSTALL_PATH, skipping installation."
    exit 0
fi

# check if vivado installer is provided
if [ "$#" -ne 2 ]; then
    echo "Vivado installer not provided. Please download the Vivado 2023.2 installer from https://www.xilinx.com/member/forms/download/xef.html?filename=FPGAs_AdaptiveSoCs_Unified_2023.2_1013_2256_Lin64.bin"
    exit 1
fi

VIVADO_INSTALLER=$2

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
