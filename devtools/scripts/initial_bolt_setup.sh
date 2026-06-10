#!/bin/bash

set -ev
if ([ -z "${SSTATE_PATH}" ] || [ -z "${DOWNLOADS_PATH}" ]) && [ "$1" != "NOCACHE" ]
then
    echo "You did not pass an sstate-cache path or downloads path when starting the container.
    This will make the initial setup and build much slower. If that is intentional, pass 'NOCACHE'."
    exit 1
fi

if [ -n "${DOWNLOADS_PATH}" ]
then
    echo DL_DIR=\"${DOWNLOADS_PATH}\" >> ${REPO_ROOT}/build/conf/local.conf
fi

if [ -n "${SSTATE_PATH}" ]
then
    echo SSTATE_DIR=\"${SSTATE_PATH}\" >> ${REPO_ROOT}/build/conf/local.conf
fi

if ! [ -d ${REPO_ROOT}/bolts ]
then
    mkdir ${REPO_ROOT}/bolts
fi

cd ${REPO_ROOT}/build

if ! grep rm_work conf/local.conf
then
    echo 'INHERIT += "rm_work"' >> conf/local.conf
    echo RM_WORK_EXCLUDE:append:class-native = \" \${PN}\" >> conf/local.conf
    echo RM_WORK_EXCLUDE:append:class-nativesdk = \" \${PN}\" >> conf/local.conf
fi

bitbake nodejs-native

bitbake bolt-env && hash bolt
bitbake base-bolt-image

# Add the meta-bolt package-config location so `bolt make base` can resolve it.
echo "${REPO_ROOT}/deps/bolt" >> ${REPO_ROOT}/build/conf/setup.done

cd ${REPO_ROOT}/bolts

bolt make base
bolt make flutter.runtime.flutter-auto.v3_38_3
bolt make flutter.runtime.flutter-auto-debug.v3_38_3
bolt make flutter.runtime.flutter-auto-profile.v3_38_3
