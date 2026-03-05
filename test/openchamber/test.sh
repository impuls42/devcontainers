#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'openchamber' Feature with no options.
#
# Eg:
# {
#    "image": "<..some-base-image...>",
#    "features": {
#      "openchamber": {}
#    },
#    "remoteUser": "root"
# }
#
# This test can be run with the following command:
#
#    devcontainer features test          \
#               --features openchamber   \
#               --remote-user root       \
#               --skip-scenarios         \
#               --base-image mcr.microsoft.com/devcontainers/base:ubuntu \
#               /path/to/this/repo

# set -x

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "bun is installed" which bun
check "opencode is installed" which opencode
check "openchamber is installed" which openchamber

# Check that the post-start script exists
check "post-start script exists" test -f /usr/local/share/openchamber/post-start.sh

# Report results
reportResults
