#!/bin/bash

set -e

TOPLEVEL=$(git rev-parse --show-toplevel)
if [ "$PWD" !=  "${TOPLEVEL}" ]
then
    echo "the script should be run with \$PWD in root of meta-bolt-flutter - ${TOPLEVEL}; current: $PWD"
    exit 1
else
    REPO_ROOT=$PWD

    # Apollo+1 stores writable Bolt data under /media/mass_storage/data instead of /data.
    # Update the local Bolt config in place and keep a backup next to the original file.
    BOLT_PATH=$(which bolt)
    echo "found bolt at: $BOLT_PATH"
    BOLT_CONFIG_FILE=$(dirname "$BOLT_PATH")/../share/bolt/src/config.cjs
    cp ${BOLT_CONFIG_FILE} ${BOLT_CONFIG_FILE}.backup
    sed -i 's/"\/data\//"\/media\/mass_storage\/data\//g' ${BOLT_CONFIG_FILE}

    echo "bolt tool config.cjs file modified; backup saved as .backup"
    echo "diff:"
    diff --unified ${BOLT_CONFIG_FILE}.backup ${BOLT_CONFIG_FILE}
fi
