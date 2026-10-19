#!/usr/bin/env bash
set -euo pipefail

GODOT_VERSION="${GODOT_VERSION:-4.7.2-stable}"
GODOT_BIN="/usr/local/bin/godot"

if [[ -x "$GODOT_BIN" ]]; then
  installed="$("$GODOT_BIN" --version 2>/dev/null | head -n1 || true)"
  wanted="${GODOT_VERSION%-stable}"
  if [[ -n "$installed" && "$installed" == *"$wanted"* ]]; then
    echo "Godot already installed: $installed"
    exit 0
  fi
fi

sudo apt-get update -qq
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  ca-certificates curl unzip \
  libfontconfig1 libgl1 libxcursor1 libxinerama1 libxrandr2 libxi6 libxss1 libasound2t64

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

zip_name="Godot_v${GODOT_VERSION}_linux.x86_64.zip"
url="https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}/${zip_name}"

curl -fsSL -o "$tmpdir/godot.zip" "$url"
unzip -qo "$tmpdir/godot.zip" -d "$tmpdir"
sudo install -m 0755 "$tmpdir/Godot_v${GODOT_VERSION}_linux.x86_64" "$GODOT_BIN"

echo "Installed: $("$GODOT_BIN" --version)"
