**WORK IN PROGRESS**

# Flutter Bolt Development Tools

This directory contains helper scripts, templates, and container tooling used to build, package, and debug Flutter applications for a Bolt-based target device.

## General usage flow

1. clone meta-bolt-flutter

2. build the docker image:

```bash
devtools/flutter_bolt_dev_container.sh dockerbuild
```

3. run the first-time init if the workspace has not been synced/built yet:

```bash
devtools/flutter_bolt_dev_container.sh first_time_init (...)
```

4. start the container (need to pass some parameters; see later sections)

```bash
devtools/flutter_bolt_dev_container.sh start (...)
```

The initial cold build takes quite a lot of time, might be like 1-2h. This is greatly improved if downloads and sstate-cache are provided, prewarmed with outputs from some already finished build (--downloads-path and --sstate-path parameters). At the moment only local-folder sstate/downloads are supported (no mirrors etc.). With sstate/downloads, the build should not take more than maybe 10 minutes.

5. update & copy custom_devices.json to local flutter config dir (like ~/.config/flutter/custom_devices.json). This will allow to build and deploy the app on the device with 'flutter' tool

from here on, it should be possible to deploy & run the app on the device in debug mode with command:

```bash
flutter run --debug -d rdkdevice
```

And also have access to devtools & the flutter console to hot-reload, enable some more devtools like showing the UI construction lines etc.

## some current limitations

- there is only 'debug' mode support in the scripting right now; should be possible to build & deploy the app in profile/release, but manually, from within the container session

- the devtools port is hardcoded on the device (22342)

- screen size (1080p) & pixel ratio (16.0/9.0) are currently hardcoded in the launch script

## Prerequisites

Before starting the container workflow, make sure that:

- the `meta-bolt-flutter` repository is available at `${ROOT_DIR}`
- the Flutter application source code is available at `${APP_DIR}`
- a debug Bolt package configuration already exists for the application, for example `flutter.app.wonderous-debug`; this becomes `${BOLT_NAME}`
- the target STB is reachable at `${STB_IP}`
- you know the BitBake recipe name for the Flutter application; this becomes `${FLUTTER_APP}`

Example application source:

```bash
git clone https://github.com/gskinnerTeam/flutter-wonderous-app.git "${APP_DIR}"
git -C "${APP_DIR}" checkout f406f017dd0e6ac8aef8a98c2904cd56cdb105ab
```

## Determine the Application Recipe

The Bolt package configuration points to the image recipe:

```bash
jq -r '.bitbake.image' package-configs/flutter.app.wonderous-debug.bolt.json
```

Example output:

```text
gskinnerteam-flutter-wonderous-app-wonders-bolt-image
```

By convention, the Flutter application recipe is the same name without the `-image` suffix:

```text
gskinnerteam-flutter-wonderous-app-wonders
```

## Example Environment

```bash
export APP_DIR=/home/tomasz.karczewski/builds/flutter-wonderous-app
export BOLT_NAME=flutter.app.wonderous-debug
export STB_IP=10.42.0.36
export FLUTTER_APP=gskinnerteam-flutter-wonderous-app-wonders
export OE_DOWNLOADS=/home/tomasz.karczewski/builds/meta-bolt-flutter/build/downloads
export OE_SSTATE_PATH=/home/tomasz.karczewski/builds/meta-bolt-flutter/build/sstate-cache
```

## Start the Development Container

For a fresh workspace, run first-time initialization before starting the app development container:

```bash
cd "${ROOT_DIR}"
devtools/flutter_bolt_dev_container.sh first_time_init \
	--downloads-path "${OE_DOWNLOADS}" \
	--sstate-path "${OE_SSTATE_PATH}"
```

If you do not have prewarmed downloads and sstate-cache directories, provide an init cache directory instead:

```bash
devtools/flutter_bolt_dev_container.sh first_time_init \
	--init-cache-path "${ROOT_DIR}/build/init-cache"
```

This creates `${ROOT_DIR}/build/init-cache/sstate` and `${ROOT_DIR}/build/init-cache/downloads`, configures BitBake to use them, and disables `rm_work` so the cold build can populate the cache. The command attaches to the container tmux session so the setup output remains visible. If setup fails, the shell stays open for debugging.

```bash
cd "${ROOT_DIR}"
devtools/flutter_bolt_dev_container.sh start \
	--project-path "${APP_DIR}" \
	--bolt-name "${BOLT_NAME}" \
	--stb-ip "${STB_IP}" \
	--application-recipe "${FLUTTER_APP}" \
	--downloads-path "${OE_DOWNLOADS}" \
	--sstate-path "${OE_SSTATE_PATH}"
```

On the first run, `repo sync` may fetch a large number of dependencies, so setup can take a while.

## Attach to the Container Session

```bash
devtools/flutter_bolt_dev_container.sh bash
```

The shell runs inside a `tmux` session. Exiting the shell stops the session and shuts down the container. To detach from `tmux` without stopping the container, use `Ctrl+B`, then `D`.

## Main Commands

The container wrapper supports the following commands:

- `start`: start the development container
- `first_time_init`: run repo setup and the initial Bolt build in a tmux session
- `bash`: attach to the `tmux` session inside the container
- `make`: build the configured Flutter Bolt package
- `push`: push the built Bolt package to the target device
- `makepush`: build and push in one step
- `debug`: start the app and print the Dart VM service endpoint
- `stop`: stop the container
- `dockerbuild`: build the local development container image
- `ctrlc`: send `Ctrl+C` to the active `tmux` session

## Notes

- Passing `--downloads-path` and `--sstate-path` is strongly recommended to reduce setup and build times.
- The scripts in `onemw/` contain additional helpers for Apollo+1 / OneMW-specific environments.
