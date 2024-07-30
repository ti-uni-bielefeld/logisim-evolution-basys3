#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if [ ! -f "$SCRIPT_DIR/logisim-evolution.jar" ]; then
    echo "File not found: $SCRIPT_DIR/logisim-evolution.jar"
    echo "Please run install_logisim-evolution.sh to install logisim-evolution"
    exit 1
fi
JAVA_PATH=$SCRIPT_DIR/../java
if [ ! "$(ls -A $JAVA_PATH)" ]; then
    echo "Java is not installed. Please run install_java.sh to install Java first."
    exit 1
fi
NEWEST_JAVA=$(ls -r $JAVA_PATH | head -n 1)
JAVA_HOME=$(realpath $JAVA_PATH/$NEWEST_JAVA)
$JAVA_HOME/bin/java -jar $SCRIPT_DIR/logisim-evolution.jar
