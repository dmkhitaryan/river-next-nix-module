#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash zig common-updater-scripts nix zon2nix nix-prefetch-git gnused jq nixfmt wget

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source "$SCRIPT_DIR/../update-lib.sh"

latest_tag=$(list-git-tags --url=https://codeberg.org/machi/machi | sed 's/^v//' | sort --version-sort | tail --lines=1)
hash=$(nix-prefetch-git --url https://codeberg.org/machi/machi --rev "v$latest_tag" | jq -r '.hash')

update_src "$SCRIPT_DIR/package.nix" "$latest_tag" "$hash"

wget "https://codeberg.org/machi/machi/raw/tag/v${latest_tag}/build.zig.zon" -O "$SCRIPT_DIR/build.zig.zon"
zon2nix "$SCRIPT_DIR/build.zig.zon" > "$SCRIPT_DIR/build.zig.zon.nix"

sed -i 's|url = "\(https://[^"?]*\)?ref=[^"]*"|url = "\1"|g' "$SCRIPT_DIR/build.zig.zon.nix"
nixfmt "$SCRIPT_DIR/build.zig.zon.nix"

rm -f "$SCRIPT_DIR/build.zig.zon"
