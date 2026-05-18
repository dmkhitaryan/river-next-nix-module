#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts git nix-prefetch-git gnused zon2nix jq nixfmt ed
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR" || exit 1

source ../window-managers/update-lib.sh

latest_tag=$(list-git-tags --url=https://github.com/kewuaa/kwim| sed 's/^v//' | sort --version-sort | tail --lines=1)
update_zig_package \
  "https://github.com/kewuaa/kwim" \
  "v$latest_tag" \
  "$latest_tag" \
  package.nix \
  build.zig.zon.nix \
  kwim
