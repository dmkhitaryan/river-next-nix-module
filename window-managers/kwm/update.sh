#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts git nix nix-prefetch-git gnused zig_0_16 zon2nix jq nixfmt ed
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR" || exit 1

source ../update-lib.sh
update_zig_package \
  "https://github.com/kewuaa/kwm" \
  refs/heads/master \
  package.nix \
  build.zig.zon.nix \
  kwm
