#!/usr/bin/env bash

set -e

source /opt/docker-utils.sh

sanitize_cgroups

/usr/local/bin/startup.sh

# Required or some images like vault fails to run properly
# @TODO search/explain the real reason
mount | grep "none on /tmp type tmpfs" >/dev/null && umount /tmp

"$@"
