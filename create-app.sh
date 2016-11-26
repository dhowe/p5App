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
JARS_DIR=${3:-${PROJECT_HOME}/lib}

APPNAME="${MAIN_CLASS#*.}"
PROJECT_BIN=${PROJECT_HOME}/bin
PROCESSING_JAVA=processing-java
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


echo Creating ${APPNAME}

# set things up
rm -rf tmp
mkdir tmp
rm -rf ${APPNAME}
mkdir ${APPNAME}
mkdir ${APPNAME}/code

 # generate the .pde file from template
cat template.pde | sed -e "s/%MAIN_CLASS%/${MAIN_CLASS}/" > ${APPNAME}/${APPNAME}.pde

# copy in the classes
cp -r ${PROJECT_BIN}/* tmp/

# and create a jar in code folder
cd tmp && jar cf ../${APPNAME}/code/app.jar * && cd -

# copy rest of jars from eclipse folder
cp -r $JARS_DIR/*.jar ${APPNAME}/code/

# clean things up before export
rm -rf ${APPNAME}/code/core.jar # core.jar not needed in p5
rm -rf  ${APPNAME}/application.* # only exists if run repeatedly
rm -rf /Users/$USER/.Trash/application.* # remove from trash as will cause an error

# lets do the export
$PROCESSING_JAVA --sketch=${DIR}/${APPNAME} --force --export > ${APPNAME}.log 2>&1

# now, copy any natives from eclipse folder
cp -r $PROJECT_HOME/*.jnilib ${APPNAME}/application.macosx/${APPNAME}.app/Contents/Java

# remove our garbage and open the folder
rm -rf tmp
echo done
open ./${APPNAME}
