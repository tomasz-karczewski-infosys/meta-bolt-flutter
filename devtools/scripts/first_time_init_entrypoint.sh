#!/bin/bash

# Map the flutter-dev user to the requesting host user's UID and GID if provided.
if [ -n "$HOST_UID" ] && [ -n "$HOST_GID" ]; then
    if [ "$HOST_GID" -ne "$(id -g flutter-dev)" ]; then
        groupmod -o -g "$HOST_GID" flutter-dev
    fi
    if [ "$HOST_UID" -ne "$(id -u flutter-dev)" ]; then
        usermod -o -u "$HOST_UID" flutter-dev
    fi
    chown -R flutter-dev:flutter-dev /home/flutter-dev
fi

exec sudo --preserve-env=REPO_ROOT,HOST_UID,HOST_GID,SSTATE_PATH,DOWNLOADS_PATH,INIT_CACHE_PATH -H -u flutter-dev bash <<'EOF'
tmux new-session -d -s dev "/usr/local/bin/first_time_init_tmux.sh"

while tmux has-session -t dev 2>/dev/null; do
    sleep 2
done
EOF