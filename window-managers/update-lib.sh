#!/usr/bin/env bash
# Shared helpers for river-next update scripts.
#
# update_src <nix-file> <new-rev> <new-hash>
#   Replaces the `rev` string and the `hash` that immediately follows it in
#   the same fetch block, without touching any other hash fields in the file
#   (e.g. overrideAttrs blocks such as libxkbcommon or meson overrides).
update_src() {
  local file="$1" tag="$2" hash="$3"
  sed -i "s|version = \"[^\"]*\"|version = \"$tag\"|" "$file"
  awk -v h="$hash" '
    /tag = "/ { found=1 }
    found && /hash = "/ { sub(/hash = "[^"]*"/, "hash = \"" h "\""); found=0 }
    1
  ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
}
