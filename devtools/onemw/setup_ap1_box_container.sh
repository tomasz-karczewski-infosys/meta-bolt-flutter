#!/bin/bash

# env: REPO_ROOT,HOST_UID,HOST_GID,FLUTTER_PROJECT_SOURCE_CODE_PATH,FLUTTER_BOLT_NAME,STB_IP,FLUTTER_APPLICATION_RECIPE
set -e

TOPLEVEL=`git rev-parse --show-toplevel`
if [ "$PWD" !=  "${TOPLEVEL}" ]
then
    echo "the script should be run with \$PWD in root of meta-bolt-flutter - ${TOPLEVEL}; current: $PWD"
    exit 1
else
    REPO_ROOT=$PWD

    # a hack to 'reconfigure' some bolt folders that are not writeable on apollo+1
    # and it's not really possible to overlay top level dir. so changing 'data/' paths to
    # '/media/mass_storage/data/' that can be written on apollo+1 onemw build 
    # note that we're patching bolt tool implementation in place ...
    BOLT_PATH=$(which bolt)
    echo "found bolt at: $BOLT_PATH"
    BOLT_CONFIG_FILE=$(dirname $BOLT_PATH)/../share/bolt/src/config.cjs
    cp ${BOLT_CONFIG_FILE} ${BOLT_CONFIG_FILE}.backup
    sed -i 's/"\/data\//"\/media\/mass_storage\/data\//g' ${BOLT_CONFIG_FILE}

    echo "bolt tool config.cjs file modified; backup saved as .backup"
    echo "diff:"
    diff --unified ${BOLT_CONFIG_FILE}.backup ${BOLT_CONFIG_FILE}
fi
