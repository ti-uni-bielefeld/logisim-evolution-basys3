#!/bin/bash

set -e # exit on error

TMP_GIT_REPO_DIR="${TMPDIR:-/tmp}/tmp-logisim-evolution-git-repo"
ORIG_DIR=$(pwd)
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
INSTALL_PATH=$(realpath $SCRIPT_DIR/logisim-evolution)
VIVADO_PATH=$INSTALL_PATH/../Xilinx/Vivado
# check if vivado is installed
if [ ! -d "$VIVADO_PATH" ]; then
    echo "Vivado is not installed. Please run install_vivado.sh to install Vivado first."
    exit 1
fi
NEWEST_VIVADO=$(ls -r $VIVADO_PATH | head -n 1)
VIVADO_BIN_PATH=$(realpath $VIVADO_PATH/$NEWEST_VIVADO/bin)

# check if JAVA_HOME is set
if [ -z "$JAVA_HOME" ]; then
    echo "JAVA_HOME is not set. Please set JAVA_HOME to the path of your installation of Java 21 or later."
    exit 1
fi

# check if java exists in JAVA_HOME
if [ ! -f "$JAVA_HOME/bin/java" ]; then
    echo "Java not found in JAVA_HOME: $JAVA_HOME. Please set JAVA_HOME to the path of your installation of Java 21 or later."
    exit 1
fi

# check java version
JAVA_VERSION=$("$JAVA_HOME/bin/java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
if [ "$(echo "$JAVA_VERSION" | cut -d'.' -f1)" -lt 21 ]; then
    echo "Java version $JAVA_VERSION is not supported. Please set JAVA_HOME to the path of your installation of Java 21 or later."
    exit 1
fi

echo "Installing logisim-evolution to $INSTALL_PATH"

# put correct JAVA_HOME in run script
sed -i "s|^JAVA_HOME=.*$|JAVA_HOME=$JAVA_HOME|g" $INSTALL_PATH/run.sh

rm -rf $TMP_GIT_REPO_DIR
echo "Cloning into temporary directory '$TMP_GIT_REPO_DIR'..."
git clone --depth 1 https://github.com/logisim-evolution/logisim-evolution $TMP_GIT_REPO_DIR
cd $TMP_GIT_REPO_DIR
echo "Applying patches..."
PATCH_DIR=$INSTALL_PATH/patches
PATCHES=$(ls $PATCH_DIR/*.patch 2>/dev/null || true)
for patch in $PATCHES; do
    echo "Applying patch $(basename $patch)..."
    git apply $patch
done
# set correct default vivado path
sed -i "s|DEFAULT_VIVADO_TOOL_PATH = \"[^\"]*\"|DEFAULT_VIVADO_TOOL_PATH = \"$VIVADO_BIN_PATH\"|g" src/main/java/com/cburch/logisim/prefs/AppPreferences.java
echo "Building Logisim..."
JAVA_HOME=$JAVA_HOME ./gradlew shadowJar
cp build/libs/logisim-evolution-*.jar $INSTALL_PATH/logisim-evolution.jar
cd $ORIG_DIR
echo "Cleaning up..."
rm -rf $TMP_GIT_REPO_DIR

echo "Successfully installed logisim-evolution to $INSTALL_PATH"