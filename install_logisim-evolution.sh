#!/bin/bash

set -e # exit on error

ORIG_DIR=$(pwd)
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
INSTALL_PATH=$(realpath $SCRIPT_DIR/logisim-evolution)
GIT_REPO_DIR=$INSTALL_PATH/git_repo

VIVADO_PATH=$SCRIPT_DIR/Xilinx/Vivado
# check if vivado is installed
if [ ! -d "$VIVADO_PATH" ]; then
    echo "Vivado is not installed. Please run install_vivado.sh to install Vivado first."
    exit 1
fi
NEWEST_VIVADO=$(ls -r $VIVADO_PATH | head -n 1)
VIVADO_BIN_PATH=$(realpath $VIVADO_PATH/$NEWEST_VIVADO/bin)/

JAVA_PATH=$SCRIPT_DIR/java
if [ ! "$(ls -A $JAVA_PATH)" ]; then
    echo "Java is not installed. Please run install_java.sh to install Java first."
    exit 1
fi
NEWEST_JAVA=$(ls -r $JAVA_PATH | head -n 1)
JAVA_HOME=$(realpath $JAVA_PATH/$NEWEST_JAVA)

# check java version
JAVA_VERSION=$($JAVA_HOME/bin/java -version 2>&1 | head -n 1 | cut -d '"' -f 2)
if [[ "$JAVA_VERSION" < "21" ]]; then
    echo "Java version $JAVA_VERSION is not supported. Please run install_java.sh to install a supported Java version."
    exit 1
fi

echo "Installing logisim-evolution to $INSTALL_PATH"

# clone if repo dir doesn't exist or is empty
if [ ! -d "$GIT_REPO_DIR" ] || [ ! "$(ls -A $GIT_REPO_DIR)" ]; then
    echo "Cloning into directory '$GIT_REPO_DIR'..."
    git clone --depth 1 https://github.com/logisim-evolution/logisim-evolution $GIT_REPO_DIR
    cd $GIT_REPO_DIR
else
    cd $GIT_REPO_DIR
    # clean repo and pull latest changes
    git reset --hard
    git clean -fd
    git pull
fi
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

echo "Successfully installed logisim-evolution to $INSTALL_PATH"