#!/bin/bash
set -e

# setup ros environment



source "$ATHOME_WS/devel/setup.bash"
exec "$@"