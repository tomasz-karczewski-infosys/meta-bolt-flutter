#!/bin/bash

# env: REPO_ROOT,HOST_UID,HOST_GID,FLUTTER_PROJECT_SOURCE_CODE_PATH,FLUTTER_BOLT_NAME,STB_IP,FLUTTER_APPLICATION_RECIPE

cd ${REPO_ROOT}
git clone https://github.com/rdkcentral/bolt-tools
# 74116 config happens to work for 72127 as well
cp bolt-tools/gpu-layer-poc/brcm974116sff.json bolt-tools/gpu-layer-poc/brcm972127ott.json

ssh root@${STB_IP} 'bash -s' < create_ap1_gpu_layer_overlay.sh

# a hack to 'reconfigure' some bolt folders that are not writeable on apollo+1
# and it's not really possible to overlay top level dir ...
BOLT_CONFIG_FILE=$(dirname $(which bolt))/../share/bolt/src/config.cjs
sed -i 'data\//media\/mass_storage\/data\//g' ${BOLT_CONFIG_FILE}


