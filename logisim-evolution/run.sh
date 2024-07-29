#!/bin/bash
JAVA_HOME=/usr/lib/jvm/default
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if [ ! -f "$SCRIPT_DIR/logisim-evolution.jar" ]; then
    echo "File not found: $SCRIPT_DIR/logisim-evolution.jar"
    echo "Please run install.sh to install logisim-evolution"
    exit 1
fi
$JAVA_HOME/bin/java -jar $SCRIPT_DIR/logisim-evolution.jar
