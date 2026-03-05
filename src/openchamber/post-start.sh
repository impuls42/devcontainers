#!/bin/bash
# Copies mounted opencode auth file into the user's config directory.
# Intended to run as a postStartCommand lifecycle hook.

MOUNTED_FILE="/mnt/opencode-auth.json"
TARGET_DIR="${HOME}/.local/share/opencode"
TARGET_FILE="${TARGET_DIR}/auth.json"

if [ -f "$MOUNTED_FILE" ] && ([ ! -f "$TARGET_FILE" ] || [ "$MOUNTED_FILE" -nt "$TARGET_FILE" ]); then
    mkdir -p "$TARGET_DIR"
    cp "$MOUNTED_FILE" "$TARGET_FILE"
    chmod 600 "$TARGET_FILE"
fi
