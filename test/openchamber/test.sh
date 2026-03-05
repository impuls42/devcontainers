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

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "opencode is installed" bash -c "which opencode"
check "openchamber is installed" bash -c "which openchamber"

# Check that the auth function was injected into bashrc
check "bashrc contains auth function" bash -c "grep '_opencode_mount_auth' ~/.bashrc"

# Report results
reportResults
