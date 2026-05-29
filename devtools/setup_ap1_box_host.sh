#!/bin/bash

# env: REPO_ROOT,HOST_UID,HOST_GID,FLUTTER_PROJECT_SOURCE_CODE_PATH,FLUTTER_BOLT_NAME,STB_IP,FLUTTER_APPLICATION_RECIPE
set -ev

# the script should be run from root of meta-bolt-flutter!

echo 1:$1

STB_IP=$1

if [ "$STB_IP" = "" ]
then
    echo "provide stb ip in first parameter"
    exit 1
fi

if [ `basename $PWD` != 'meta-bolt-flutter' ]
then
    echo "the script should be run with \$PWD in root of meta-bolt-flutter; current: $PWD"
    exit 1
fi

REPO_ROOT=`pwd`

cd ${REPO_ROOT}

if ! [ -d bolt-tools ]
then
    git clone --depth=1 https://github.com/rdkcentral/bolt-tools
else
    pushd bolt-tools
    git reset --hard
    git clean -xdf
    popd
fi
# 74116 config happens to work for 72127 as well
cp bolt-tools/gpu-layer-poc/brcm974116sff.json bolt-tools/gpu-layer-poc/brcm972127ott.json

# alias ssh='ssh -o StrictHostKeyChecking=no'
ssh -o StrictHostKeyChecking=no root@${STB_IP} 'bash -s' < devtools/create_ap1_gpu_layer_overlay.sh || true

# a hack to 'reconfigure' some bolt folders that are not writeable on apollo+1
# and it's not really possible to overlay top level dir. so changing 'data/' paths to
# '/media/mass_storage/data/' that can be written on apollo+1 onemw build 
# note that we're patching bolt tool implementation in place ...
BOLT_PATH=$(which bolt)
echo "patching bolt at: $BOLT_PATH"
BOLT_CONFIG_FILE=$(dirname $BOLT_PATH)/../share/bolt/src/config.cjs
sed -i 'data\//media\/mass_storage\/data\//g' ${BOLT_CONFIG_FILE}

echo "bolt tool config.cjs file modified; current content:"
cat ${BOLT_CONFIG_FILE}

