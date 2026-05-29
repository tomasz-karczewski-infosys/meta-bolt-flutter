#!/bin/bash


# env: REPO_ROOT,HOST_UID,HOST_GID,FLUTTER_PROJECT_SOURCE_CODE_PATH,FLUTTER_BOLT_NAME,STB_IP,FLUTTER_APPLICATION_RECIPE

git config --global user.email "you@example.com"
git config --global user.name "Your Name"
# no color prevents repo-tool from asking questions interactively
git config --global color.ui false

# avoid key checks (that break on user input)
alias ssh='ssh -o StrictHostKeyChecking=no'

cd ${REPO_ROOT}
. setup-environment 

cd ${REPO_ROOT}/build

# remove old flutter-bolt-dev blocks
awk -f - conf/local.conf >conf/local.conf.updated <<EOF
    /@START flutter-bolt-dev/    {DELETING="1"}
    /@END flutter-bolt-dev/      {DELETING="0"}
    !/@END flutter-bolt-dev/     {if (DELETING!="1") print}
EOF

mv conf/local.conf.updated conf/local.conf

cat >> conf/local.conf <<EOF
## @START flutter-bolt-dev
INHERIT += "externalsrc"
EXTERNALSRC:pn-${FLUTTER_APPLICATION_RECIPE} = "/home/tomasz.karczewski/copilot/flutter-wonderous-app"
EXTERNALSRC_BUILD:pn-${FLUTTER_APPLICATION_RECIPE} = "/home/tomasz.karczewski/copilot/flutter-wonderous-app/yocto_build"
PUBSPEC_IGNORE_LOCKFILE:pn-${FLUTTER_APPLICATION_RECIPE} = "0"
FLUTTER_APP_RUNTIME_MODES:pn-${FLUTTER_APPLICATION_RECIPE} = "debug"
## @END flutter-bolt-dev
EOF
