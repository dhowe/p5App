#!/bin/sh

# 1. run your program in eclipse
# 2. run this script: ./create-app.sh [main-class] [path-to-eclipse-bin-folder]
# 3. run the AppRunner/AppRunner.pde sketch in this directory from Processing
# 4. choose file->'export application' from Processing menu
# 5. test the exported application
#
# Assumptions: running from OSX

MAIN_CLASS=${1}
PROJECT_HOME=${2}
PROJECT_BIN=${PROJECT_HOME}/bin
JARS_DIR=${3:-${PROJECT_HOME}/lib}
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#CORE_JAR=${3:-/Applications/Processing.app/Contents/Java/core.jar}

# set things up
rm -rf tmp
mkdir tmp
rm -rf AppRunner
mkdir AppRunner
mkdir AppRunner/code

 # generate the .pde file from template
cat template.pde | sed -e "s/%MAIN_CLASS%/${MAIN_CLASS}/" > AppRunner/Apprunner.pde

# copy in the classes
cp -r ${PROJECT_BIN}/* tmp/

# and create a jar in code folder
cd tmp && jar cvf ../AppRunner/code/app.jar * && cd -

# copy rest of jars from eclipse folder
cp -r $JARS_DIR/*.jar AppRunner/code/

# clean things up before export
rm -rf AppRunner/code/core.jar # core.jar not needed in p5
rm -rf  AppRunner/application.* # only exists if run repeatedly
rm -rf /Users/$USER/.Trash/application.* # remove from trash as will cause an error

# lets do the export
processing-java --sketch=${DIR}/AppRunner --force --export

# remove our garbage and open the folder
rm -rf tmp
open ./AppRunner
