#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts nix-prefetch-git gnused zon2nix jq nixfmt wget

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source "$SCRIPT_DIR/../update-lib.sh"

latest_tag=$(list-git-tags --url=https://git.sr.ht/~hokiegeek/orilla | sed 's/^orilla-v//; s/^v//' | sort --version-sort | tail --lines=1)
hash=$(nix-prefetch-git --url https://git.sr.ht/~hokiegeek/orilla --rev "$latest_tag" | jq -r '.hash')

update_src "$SCRIPT_DIR/package.nix" "$latest_tag" "$hash"
