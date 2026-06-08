#!/bin/bash

set -ev

STB_IP=$1

if [ "$STB_IP" = "" ]
then
    echo "provide stb ip in first parameter"
    exit 1
fi

TOPLEVEL=$(git rev-parse --show-toplevel)
if [ "$PWD" !=  "${TOPLEVEL}" ]
then
    echo "the script should be run with \$PWD in root of meta-bolt-flutter - ${TOPLEVEL}; current: $PWD"
    exit 1
fi

REPO_ROOT=$PWD

cd ${REPO_ROOT}

if ! [ -d bolt-tools ]
then
    git clone --depth=1 https://github.com/rdkcentral/bolt-tools ${REPO_ROOT}/bolt-tools
else
    pushd bolt-tools
    git reset --hard
    git clean -xdf
    popd
fi
# Reuse the closest available GPU-layer config for the 972127 target.
cp ${REPO_ROOT}/bolt-tools/gpu-layer-poc/brcm974116sff.json ${REPO_ROOT}/bolt-tools/gpu-layer-poc/brcm972127ott.json

ssh -o StrictHostKeyChecking=no root@${STB_IP} 'bash -s' < ${REPO_ROOT}/devtools/onemw/create_ap1_gpu_layer_overlay.sh 

cd ${REPO_ROOT}/bolt-tools/gpu-layer-poc/
MODE=bind ./setup-gpu-layer.sh root@${STB_IP}

