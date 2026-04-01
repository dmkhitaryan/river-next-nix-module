#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts nix-prefetch-git gnused zon2nix jq nixfmt wget

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

latest_tag=$(list-git-tags --url=https://codeberg.org/lzj15/rill | sed 's/^v//' | sort --version-sort | tail --lines=1)
hash=$(nix-prefetch-git --url https://codeberg.org/lzj15/rill --rev "$latest_tag" | jq -r '.hash')

source "$SCRIPT_DIR/../update-lib.sh"
update_src "$SCRIPT_DIR/package.nix" "$latest_tag" "$hash"

wget "https://codeberg.org/lzj15/rill/raw/tag/${latest_tag}/build.zig.zon" -O "$SCRIPT_DIR/build.zig.zon"
zon2nix "$SCRIPT_DIR/build.zig.zon" > "$SCRIPT_DIR/build.zig.zon.nix"

sed -i 's|url = "\(https://[^"?]*\)?ref=[^"]*"|url = "\1"|g' "$SCRIPT_DIR/build.zig.zon.nix"
nixfmt "$SCRIPT_DIR/build.zig.zon.nix"

rm -f "$SCRIPT_DIR/build.zig.zon"
