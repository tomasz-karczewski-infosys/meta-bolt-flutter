#!/bin/bash
# env: REPO_ROOT,HOST_UID,HOST_GID,FLUTTER_PROJECT_SOURCE_CODE_PATH,FLUTTER_BOLT_NAME,STB_IP,FLUTTER_APPLICATION_RECIPE

git config --global user.email "you@example.com"
git config --global user.name "Your Name"
# no color prevents repo-tool from asking questions interactively
git config --global color.ui false
export REPO_ROOT

# avoid key checks (that break on user input)
alias ssh='ssh -o StrictHostKeyChecking=no'

cd ${REPO_ROOT}
. setup-environment 

if [ -d ${REPO_ROOT}/build ] && [ -f ${REPO_ROOT}/build/conf/local.conf ]
then
    cd ${REPO_ROOT}/build
    # remove old flutter-bolt-dev blocks
    awk -f - conf/local.conf >conf/local.conf.updated <<EOF
/@START flutter-bolt-dev/    {DELETING="1"}
/@END flutter-bolt-dev/      {DELETING="0"}
!/@END flutter-bolt-dev/     {if (DELETING!="1") print}
EOF

    mv conf/local.conf.updated conf/local.conf

    # add new flutter-bolt-dev block
    cat >> conf/local.conf <<EOF
## @START flutter-bolt-dev
INHERIT += "externalsrc"
EXTERNALSRC:pn-${FLUTTER_APPLICATION_RECIPE} = "${FLUTTER_PROJECT_SOURCE_CODE_PATH}"
EXTERNALSRC_BUILD:pn-${FLUTTER_APPLICATION_RECIPE} = "${FLUTTER_PROJECT_SOURCE_CODE_PATH}/yocto_build"
# TODO: not a general thing; should probably be removed TODO
# BUT: "0" might be necessary if you first build the app outside of meta-bolt-flutter? TODO check
PUBSPEC_IGNORE_LOCKFILE:pn-${FLUTTER_APPLICATION_RECIPE} = "1"
FLUTTER_APP_RUNTIME_MODES:pn-${FLUTTER_APPLICATION_RECIPE} = "debug"
## @END flutter-bolt-dev
EOF

fi

export FLUTTER_BOLT_CONFIG=$(jq .config < ${REPO_ROOT}/package-configs/${FLUTTER_BOLT_NAME}.bolt.json | tr -d '"')

ID=$(jq .id < ${REPO_ROOT}/package-configs/${FLUTTER_BOLT_CONFIG} | tr -d '"')
VER=$(jq .version < ${REPO_ROOT}/package-configs/${FLUTTER_BOLT_CONFIG} | tr -d '"')
export FLUTTER_OUTPUT_BOLT_NAME=${ID}+${VER}

! [ -d ~/.ssh ] && mkdir ~/.ssh
cat > ~/.ssh/config <<EOF
Host *
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
EOF