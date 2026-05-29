#!/bin/bash

set -ev

# env: REPO_ROOT,HOST_UID,HOST_GID,FLUTTER_PROJECT_SOURCE_CODE_PATH,FLUTTER_BOLT_NAME,STB_IP,FLUTTER_APPLICATION_RECIPE

if ! [ -d ${REPO_ROOT}/bolts ]
then
    mkdir ${REPO_ROOT}/bolts
fi

cd ${REPO_ROOT}/build

if ! grep rm_work conf/local.conf
then
    echo 'INHERIT += "rm_work"' >> conf/local.conf
fi

bitbake bolt-env && hash bolt
bitbake base-bolt-image
bitbake flutter-auto-3-38-3-runtime-bolt-image

# to make base bolt, need to give path to *meta-bolt* package-config
echo "${REPO_ROOT}/deps/bolt" >> ${REPO_ROOT}/conf/setup.done

cd ${REPO_ROOT}/bolts

bolt make base
bolt make flutter.runtime.flutter-auto.v3_38_3
bolt make flutter.runtime.flutter-auto.v3_38_3-debug

bolt make ${FLUTTER_BOLT_NAME}
