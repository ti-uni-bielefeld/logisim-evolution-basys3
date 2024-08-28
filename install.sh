#!/bin/bash

set -e # exit on error

# check if at least one argument and at most two arguments are provided
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: $0 <install_dir> [vivado_installer]"
    echo "       install_dir: directory to install Java, Vivado and Logisim Evolution to"
    echo "       vivado_installer: Vivado 2023.2 installer downloaded from https://www.xilinx.com/member/forms/download/xef.html?filename=FPGAs_AdaptiveSoCs_Unified_2023.2_1013_2256_Lin64.bin"
    echo "                         This is optional if Vivado is already installed"
    exit 1
fi

INSTALL_PATH=$1
mkdir -p $INSTALL_PATH

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cp $SCRIPT_DIR/README.md $SCRIPT_DIR/example.circ $SCRIPT_DIR/USER_MANUAL.md $INSTALL_PATH/

# set correct path to run script in user manual
sed -i "s|/path/to/logisim-evolution/run.sh|$INSTALL_PATH/logisim-evolution/run.sh|g" $INSTALL_PATH/USER_MANUAL.md

echo "Installing Java..."
./install_files/install_java.sh $INSTALL_PATH/java

echo "Installing Vivado..."
# check if vivado installer is provided
if [ "$#" -lt 2 ]; then
    ./install_files/install_vivado.sh $INSTALL_PATH/Xilinx
else
    ./install_files/install_vivado.sh $INSTALL_PATH/Xilinx $2
fi

echo "Installing Logisim Evolution..."
./install_files/install_logisim-evolution.sh $INSTALL_PATH/logisim-evolution $INSTALL_PATH/Xilinx $INSTALL_PATH/java
