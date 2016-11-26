#!/bin/sh

# Assumptions: running from OSX, with processing-java installed
#
# 1. run your program in eclipse
# 2. then run this script
# 3. test the exported application(s)
#

if [ $# -lt 2 ]; then
  echo 1>&2 "Usage: ./create-app.sh [main-class] [path-to-eclipse-project] (optional-path-to-jars-dir)"
  exit 2
fi

MAIN_CLASS=${1}
PROJECT_HOME=${2}
PROJECT_BIN=${PROJECT_HOME}/bin
JARS_DIR=${3:-${PROJECT_HOME}/lib}
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
cd tmp && jar cf ../AppRunner/code/app.jar * && cd -

# copy rest of jars from eclipse folder
cp -r $JARS_DIR/*.jar AppRunner/code/

# clean things up before export
rm -rf AppRunner/code/core.jar # core.jar not needed in p5
rm -rf  AppRunner/application.* # only exists if run repeatedly
rm -rf /Users/$USER/.Trash/application.* # remove from trash as will cause an error

# lets do the export
processing-java --sketch=${DIR}/AppRunner --force --export > AppRunner.log 2>&1

# now, copy any natives from eclipse folder
cp -r $PROJECT_HOME/*.jnilib AppRunner/application.macosx/AppRunner.app/Contents/Java

# remove our garbage and open the folder
rm -rf tmp
echo done
open ./AppRunner
