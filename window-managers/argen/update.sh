#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts git nix nix-prefetch-git gnused zig_0_16 zon2nix jq nixfmt ed
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR" || exit 1

latest_tag=$(list-git-tags --url=https://codeberg.org/pkap/argen| sed 's/^v//' | sort --version-sort | tail --lines=1)
source ../update-lib.sh
update_zig_package \
  "https://codeberg.org/pkap/argen" \
  "v$latest_tag" \
  "$latest_tag" \
  package.nix \
  build.zig.zon.nix \
  kwm
