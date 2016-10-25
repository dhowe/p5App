#!/bin/sh

# 1. run your program in eclipse
# 2. run this script: ./create-app.sh
# 3. run the AppRunner/AppRunner.pde skectch in this directory from Processing
# 4. choose file->export application from Processing menu
# 5. test the exported application

cd bin && jar cvf ../app.jar * && cd -
