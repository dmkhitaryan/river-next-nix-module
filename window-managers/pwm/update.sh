#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts git nix-prefetch-git jq ed

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR" || exit 1

source ../update-lib.sh
update_other_package \
  "https://github.com/pinpox/river-pwm" \
  refs/heads/main \
  package.nix \
  pwm
