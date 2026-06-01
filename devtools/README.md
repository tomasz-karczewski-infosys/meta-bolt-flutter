
1) initial setup steps

- clone meta-bolt-flutter repo to ${ROOT_DIR}

- have the application code in ${APP_DIR}

**HERE** https://github.com/gskinnerTeam/flutter-wonderous-app.git, then - git checkout -b 2.2.4 -m f406f017dd0e6ac8aef8a98c2904cd56cdb105ab

- have the debug package configs created for the app bolt; eg 'flutter.app.wonderous-debug' - that will be the ${BOLT_NAME}
**TODO: automate?**

- have STB reachable over ${STB_IP}

- find the bitbake flutter application ('inherit flutter-app' in the bb recipe) that builds given app, like 'gskinnerteam-flutter-wonderous-app-wonders' - ${FLUTTER_APP}

can be found like:

$ cat flutter.app.wonderous-debug.bolt.json | jq ".bitbake.image" | tr -d '"'
gskinnerteam-flutter-wonderous-app-wonders-bolt-image

by convention, the flutter app recipe will be that name, without '-image' suffix 

**TODO**
export APP_DIR=/home/tomasz.karczewski/builds/flutter-wonderous-app
export BOLT_NAME=flutter.app.wonderous-debug
export STB_IP=10.42.0.36
export FLUTTER_APP=gskinnerteam-flutter-wonderous-app-wonders
export OE_DOWNLOADS=/home/tomasz.karczewski/builds/meta-bolt-flutter/build/downloads
export OE_SSTATE_PATH=/home/tomasz.karczewski/builds/meta-bolt-flutter/build/sstate-cache
**ENDTODO**

- start the container:

cd ${ROOT_DIR}
devtools/flutter_bolt_dev_container.sh start --project-path ${APP_DIR} --bolt-name ${BOLT_NAME} --stb-ip ${STB_IP} --application-recipe ${FLUTTER_APP} --downloads-path ${OE_DOWNLOADS} --sstate-path ${OE_SSTATE_PATH}

# gskinnerteam-flutter-wonderous-app-wonders

- if this is the first time, repo sync will be fetching deps; this takes quite a while. Enter:

devtools/flutter_bolt_dev_container.sh bash

 - and monitor the progress in the session. Note that this is a **tmux** session. If you exit the bash, tmux & the whole container will shut down. If you want to just disconnect from tmux, use the keypresses: 'ctr-b d'




**TODO AUTOMATE**

- DL_DIR ?= "${TOPDIR}/downloads"

**TODO AUTOMATE end**
