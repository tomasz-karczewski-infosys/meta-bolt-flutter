#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
exec /usr/bin/flutter-auto -w 1920 -h 1080 -p 1.77777 -c -b "$@" --vm-service-host=0.0.0.0 --vm-service-port=12345 --disable-service-auth-codes
