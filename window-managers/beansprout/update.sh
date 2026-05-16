#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts git nix-prefetch-git gnused zon2nix jq nixfmt ed

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR" || exit 1

source ../update-lib.sh
update_zig_package \
  "https://codeberg.org/beansprout/beansprout" \
  refs/heads/main \
  package.nix \
  build.zig.zon.nix \
  beansprout
