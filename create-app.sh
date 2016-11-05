#!/bin/sh

# 1. run your program in eclipse
# 2. run this script: ./create-app.sh
# 3. run the AppRunner/AppRunner.pde sketch in this directory from Processing
# 4. choose file->'export application' from Processing menu
# 5. test the exported application

PROJECT_BIN=${1:-~/Documents/Projects/RELC3/bin}

mkdir tmp

cp -r ${PROJECT_BIN}/* tmp/
cd tmp && jar cvf ../app.jar * && cd -
cp app.jar AppRunner/code/
cp rita.jar AppRunner/code/
ls AppRunner/code/


rm -rf tmp
