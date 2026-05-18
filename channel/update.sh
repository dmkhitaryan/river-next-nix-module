#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts git nix-prefetch-git gnused zon2nix jq nixfmt ed

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR" || exit 1

source ../window-managers/update-lib.sh

latest_tag=$(list-git-tags --url=https://codeberg.org/Sivecano/channel| sed 's/^v//' | sort --version-sort | tail --lines=1)
update_zig_package \
  "https://codeberg.org/Sivecano/channel" \
  "$latest_tag" \
  "$latest_tag" \
  package.nix \
  build.zig.zon.nix \
  channel
