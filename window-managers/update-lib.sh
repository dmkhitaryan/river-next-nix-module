#!/usr/bin/env bash
# Shared helpers for river-next update scripts.
#
# current_version <nix-file>
#   Returns the first `version` value found in the file.
current_version() {
  local file="$1"
  sed -n 's/.*version = "\([^"]*\)".*/\1/p' "$file" | head -n1
}
#
# prefetch_field <prefetch-json> <field>
#   Extracts a field from the nix-prefetch-git JSON result.
prefetch_field() {
  local prefetch_json="$1" field="$2"
  jq -r ".$field" <<< "$prefetch_json"
}
#
# zon_digest <build.zig.zon>
#   Returns the SHA-256 digest of a build.zig.zon file in hex form.
zon_digest() {
  local zon_file="$1"
  sha256sum "$zon_file" | cut -d' ' -f1
}
#
# current_zon_digest <build.zig.zon.nix>
#   Returns the stored build.zig.zon SHA-256 digest, if present.
current_zon_digest() {
  local zon_nix_file="$1"
  sed -n 's/^# build\.zig\.zon-sha256: //p' "$zon_nix_file" | head -n1
}
#
# write_zon_digest_comment <build.zig.zon.nix> <digest>
#   Records the source build.zig.zon digest as a comment in the generated nix file.
write_zon_digest_comment() {
  local zon_nix_file="$1" digest="$2" tmp_file
  tmp_file=$(mktemp) || return 1
  {
    printf '# build.zig.zon-sha256: %s\n' "$digest"
    sed '1{/^# build\.zig\.zon-sha256: /d;}' "$zon_nix_file"
  } > "$tmp_file"
  mv "$tmp_file" "$zon_nix_file"
}
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

# update_zig_package <repo-url> <rev> <version> <nix-file> <build.zig.zon.nix> <label>
#   Reuses the prefetched source tree to read build.zig.zon. The generated nix
#   file stores the source manifest digest so zon2nix only runs when
#   dependencies actually changed.
update_zig_package() {
  local repo_url="$1" rev="$2" version="$3" nix_file="$4" zon_nix_file="$5" label="$6"
  local prefetch latest_hash latest_path latest_zon latest_zon_digest

  prefetch=$(nix-prefetch-git --url "$repo_url" --rev "$rev") || return 1
  latest_hash=$(prefetch_field "$prefetch" hash)
  latest_path=$(prefetch_field "$prefetch" path)
  latest_zon="$latest_path/build.zig.zon"
  latest_zon_digest=$(zon_digest "$latest_zon")
  if [ ! -f "$latest_zon" ]; then
    echo "$label: missing build.zig.zon in prefetched source tree" >&2
    return 1
  fi

  if [ -s "$zon_nix_file" ] && [ "$(current_zon_digest "$zon_nix_file")" = "$latest_zon_digest" ]; then
    echo "$label build.zig.zon unchanged; skipping dependency regeneration."
    update_src "$nix_file" "$version" "$latest_hash"
    return 0
  fi

  zon2nix "$latest_zon" > "$zon_nix_file" || return 1
  write_zon_digest_comment "$zon_nix_file" "$latest_zon_digest" || return 1
  sed -i 's|url = "\(https://[^"?]*\)?ref=[^"]*"|url = "\1"|g' "$zon_nix_file"
  nixfmt "$zon_nix_file"
  update_src "$nix_file" "$version" "$latest_hash"
}
