#!/usr/bin/env bash

set -e

useradd -m -s /bin/bash -u "$uid" "$user" # UID
exec gosu $user "$@"
