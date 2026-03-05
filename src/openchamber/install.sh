#!/bin/bash
set -e

USERNAME="${USERNAME:-"${_REMOTE_USER:-"automatic"}"}"

NODE_PTY_VERSION="${BUN_PTY_VERSION:-"1.1.0"}"
OPENCODE_VERSION="${OPENCODE_VERSION:-"latest"}"
OPENCHAMBER_VERSION="${OPENCHAMBER_VERSION:-latest}"

export MISE_VERBOSE=1

# Function to mount auth file - will be injected into shell rc files
OPENCODE_BASHRC='
export PATH="${HOME}/.bun/bin:$PATH"
_opencode_mount_auth() {
    local MOUNTED_FILE="/mnt/opencode-auth.json"
    local TARGET_DIR="${HOME}/.local/share/opencode"
    local TARGET_FILE="${TARGET_DIR}/auth.json"

    # Check if the mounted file exists and target file is missing or older
    if [ -f "$MOUNTED_FILE" ] && ([ ! -f "$TARGET_FILE" ] || [ "$MOUNTED_FILE" -nt "$TARGET_FILE" ]); then
        mkdir -p "$TARGET_DIR" 2>/dev/null
        cp "$MOUNTED_FILE" "$TARGET_FILE" 2>/dev/null
        chmod 600 "$TARGET_FILE" 2>/dev/null
    fi
}
_opencode_mount_auth
'

install() {
    sudo -u "${USERNAME}" bash -c "source ~/.bashrc && \
        bun install -g node-pty@${NODE_PTY_VERSION} && \
        bun install -g opencode-ai@${OPENCODE_VERSION} && \
        bun install -g @openchamber/web@${OPENCHAMBER_VERSION}"

    sudo -u "${USERNAME}" bash -c "cat >> ~/.bashrc" <<< "$OPENCODE_BASHRC"
    sudo -u "${USERNAME}" bash -c "cat >> ~/.zshrc" <<< "$OPENCODE_BASHRC"

}

echo "(*) Installing Opencode (${OPENCODE_VERSION}) and Openchamber (${OPENCHAMBER_VERSION}) via bun as default..."

install
