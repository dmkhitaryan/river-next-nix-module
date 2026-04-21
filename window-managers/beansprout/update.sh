#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts nix-prefetch-git gnused zon2nix jq nixfmt wget

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source "$SCRIPT_DIR/../update-lib.sh"

latest_tag=$(list-git-tags --url=https://codeberg.org/beansprout/beansprout | sed 's/^v//' | sort --version-sort | tail --lines=1)
hash=$(nix-prefetch-git --url https://codeberg.org/beansprout/beansprout --rev "v$latest_tag" | jq -r '.hash')

update_src "$SCRIPT_DIR/package.nix" "$latest_tag" "$hash"

wget "https://codeberg.org/beansprout/beansprout/raw/tag/v${latest_tag}/build.zig.zon" -O "$SCRIPT_DIR/build.zig.zon"
zon2nix "$SCRIPT_DIR/build.zig.zon" > "$SCRIPT_DIR/build.zig.zon.nix"

sed -i 's|url = "\(https://[^"?]*\)?ref=[^"]*"|url = "\1"|g' "$SCRIPT_DIR/build.zig.zon.nix"
nixfmt "$SCRIPT_DIR/build.zig.zon.nix"

rm -f "$SCRIPT_DIR/build.zig.zon"
