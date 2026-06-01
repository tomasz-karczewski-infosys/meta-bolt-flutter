
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

- start the container:

cd ${ROOT_DIR}
devtools/flutter_bolt_dev_container.sh start ${APP_DIR} ${BOLT_NAME} ${STB_IP} ${FLUTTER_APP}

# gskinnerteam-flutter-wonderous-app-wonders

- if this is the first time, repo sync will be fetching deps; this takes quite a while. Enter:

devtools/flutter_bolt_dev_container.sh bash

 - and monitor the progress in the session. Note that this is a **tmux** session. If you exit the bash, tmux & the whole container will shut down. If you want to just disconnect from tmux, use the keypresses: 'ctr-b d'




**TODO AUTOMATE**

- DL_DIR ?= "${TOPDIR}/downloads"

**TODO AUTOMATE end**
