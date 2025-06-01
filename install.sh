#!/bin/bash

set -e # exit on error

# check if at least one argument and at most two arguments are provided
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: $0 <install_dir> [vivado_installer]"
    echo "       install_dir: directory to install Java, Vivado and Logisim Evolution to"
    echo "       vivado_installer: Vivado 2023.2 installer downloaded from https://www.xilinx.com/member/forms/download/xef.html?filename=FPGAs_AdaptiveSoCs_Unified_2023.2_1013_2256_Lin64.bin"
    echo "                         This is not needed if Vivado should not be installed or is already installed"
    exit 1
fi

INSTALL_PATH=$(realpath $1)
mkdir -p $INSTALL_PATH

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cp -r $SCRIPT_DIR/{README.md,example.circ,user_manual/,LICENSE} $INSTALL_PATH/

# remove potentially still existing old files from previous versions
rm -f $INSTALL_PATH/USER_MANUAL.md
rm -f $INSTALL_PATH/logisim-evolution/{logisim-evolution.jar,run.sh}
rmdir $INSTALL_PATH/logisim-evolution 2>/dev/null || true

echo "Installing Java..."
./install_files/install_java.sh $INSTALL_PATH/java

# check if vivado installer is provided
if [ "$#" -ge 2 ]; then
    echo "Installing Vivado..."
    ./install_files/install_vivado.sh $INSTALL_PATH/Xilinx $2
fi

echo "Installing Logisim Evolution..."
./install_files/install_logisim-evolution.sh $INSTALL_PATH $INSTALL_PATH/Xilinx $INSTALL_PATH/java
