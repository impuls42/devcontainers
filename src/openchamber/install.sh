#!/bin/bash
set -e

USERNAME="${USERNAME:-"${_REMOTE_USER:-"automatic"}"}"

NODE_PTY_VERSION="${BUN_PTY_VERSION:-"1.1.0"}"
OPENCODE_VERSION="${OPENCODE_VERSION:-"latest"}"
OPENCHAMBER_VERSION="${OPENCHAMBER_VERSION:-latest}"

export MISE_VERBOSE=1

# PATH setup for mise shims and bun global bin
OPENCODE_PATH='export PATH="${HOME}/.local/share/mise/shims:${HOME}/.bun/bin:$PATH"'

install() {
    sudo -u "${USERNAME}" bash -c "eval \"\$(mise activate bash)\" && \
        bun install -g node-pty@${NODE_PTY_VERSION} && \
        bun install -g opencode-ai@${OPENCODE_VERSION} && \
        bun install -g @openchamber/web@${OPENCHAMBER_VERSION}"

    sudo -u "${USERNAME}" bash -c "cat >> ~/.profile" <<< "$OPENCODE_PATH"
    sudo -u "${USERNAME}" bash -c "cat >> ~/.bashrc" <<< "$OPENCODE_PATH"
    sudo -u "${USERNAME}" bash -c "cat >> ~/.zshrc" <<< "$OPENCODE_PATH"

    # Install post-start script for auth mounting
    mkdir -p /usr/local/share/openchamber
    cp "$(dirname "$0")/post-start.sh" /usr/local/share/openchamber/post-start.sh
    chmod +x /usr/local/share/openchamber/post-start.sh
}

echo "(*) Installing Opencode (${OPENCODE_VERSION}) and Openchamber (${OPENCHAMBER_VERSION}) via bun as default..."

install
