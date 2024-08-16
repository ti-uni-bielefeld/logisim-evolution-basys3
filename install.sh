#!/bin/bash

set -e # exit on error

# check if at least one argument and at most two arguments are provided
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: $0 <install_dir> [vivado_installer]"
    echo "       install_dir: directory to install Java, Vivado and Logisim Evolution to"
    echo "       vivado_installer: \"Linux Self Extracting Web Installer\" downloaded from https://www.xilinx.com/support/download.html"
    echo "                         This is optional if Vivado is already installed"
    exit 1
fi

mkdir -p $1
INSTALL_PATH=$(realpath $1)

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cp $SCRIPT_DIR/README.md $SCRIPT_DIR/example.circ $SCRIPT_DIR/USER_MANUAL.md $INSTALL_PATH/

echo "Installing Java..."
./install_files/install_java.sh $INSTALL_PATH/java

echo "Installing Vivado..."
# check if vivado installer is provided
if [ "$#" -ne 2 ]; then
    ./install_files/install_vivado.sh $INSTALL_PATH/Xilinx
else
    VIVADO_INSTALLER=$(realpath $2)
    ./install_files/install_vivado.sh $INSTALL_PATH/Xilinx $VIVADO_INSTALLER
fi

echo "Installing Logisim Evolution..."
./install_files/install_logisim-evolution.sh $INSTALL_PATH/logisim-evolution $INSTALL_PATH/Xilinx $INSTALL_PATH/java
