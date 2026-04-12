#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts git nix-prefetch-git jq
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

latest_rev=$(git ls-remote https://codeberg.org/g4b/mousetrap refs/heads/master | cut -f1)
hash=$(nix-prefetch-git --url https://codeberg.org/g4b/mousetrap --rev "$latest_rev" | jq -r '.hash')

source "$SCRIPT_DIR/../update-lib.sh"
update_src "$SCRIPT_DIR/package.nix" "$latest_rev" "$hash"
