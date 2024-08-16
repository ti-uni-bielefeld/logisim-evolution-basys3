#!/bin/bash

set -e # exit on error

# check if paths are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <install_dir> <xilinx_path> <java_path>"
    echo "       install_dir: directory to install Logisim Evolution to"
    echo "       xilinx_path: path to the Xilinx installation directory where Vivado is installed in"
    echo "       java_path: path to the Java installation directory"
    exit 1
fi

INSTALL_PATH=$(realpath $1)
VIVADO_PATH=$(realpath $2/Vivado)
JAVA_PATH=$(realpath $3)

ORIG_DIR=$(pwd)
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TMP_GIT_REPO_DIR="${TMPDIR:-/tmp}/tmp-logisim-evolution-git-repo"

# check if vivado is installed
if [ ! -d "$VIVADO_PATH" ]; then
    echo "Vivado is not installed in $VIVADO_PATH. Please run install_vivado.sh to install Vivado first."
    exit 1
fi
NEWEST_VIVADO=$(ls -r $VIVADO_PATH | head -n 1)
VIVADO_BIN_PATH=$(realpath $VIVADO_PATH/$NEWEST_VIVADO/bin)/

# check if java is installed
if [ ! "$(ls -A $JAVA_PATH)" ]; then
    echo "Java is not installed in $JAVA_PATH. Please run install_java.sh to install Java first."
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

rm -rf $TMP_GIT_REPO_DIR
echo "Cloning into temporary directory '$TMP_GIT_REPO_DIR'..."
git clone https://github.com/logisim-evolution/logisim-evolution $TMP_GIT_REPO_DIR
cd $TMP_GIT_REPO_DIR
git reset --hard 2d5f2a84775a5c4ca6d431fa7b6415fca020902b

echo "Applying patches..."
git apply $SCRIPT_DIR/logisim-evolution-patches/*.patch
# set correct default vivado path
sed -i "s|DEFAULT_VIVADO_TOOL_PATH = \"[^\"]*\"|DEFAULT_VIVADO_TOOL_PATH = \"$VIVADO_BIN_PATH\"|g" src/main/java/com/cburch/logisim/prefs/AppPreferences.java
echo "Building Logisim..."
JAVA_HOME=$JAVA_HOME ./gradlew shadowJar
mkdir -p $INSTALL_PATH
cp build/libs/logisim-evolution-*.jar $INSTALL_PATH/logisim-evolution.jar
cd $ORIG_DIR

echo "Copying example circuit and user manual..."
cp $SCRIPT_DIR/example.circ $SCRIPT_DIR/USER_MANUAL.md $INSTALL_PATH/
# set correct path to run script in user manual
sed -i "s|/path/to/logisim-evolution/run.sh|$INSTALL_PATH/run.sh|g" $INSTALL_PATH/USER_MANUAL.md

echo "Setting up run script..."
echo "#!/bin/bash" > $INSTALL_PATH/run.sh
echo "$JAVA_HOME/bin/java -jar $INSTALL_PATH/logisim-evolution.jar" >> $INSTALL_PATH/run.sh
chmod a+x $INSTALL_PATH/run.sh

echo "Cleaning up..."
rm -rf $TMP_GIT_REPO_DIR

echo "Successfully installed logisim-evolution to $INSTALL_PATH"