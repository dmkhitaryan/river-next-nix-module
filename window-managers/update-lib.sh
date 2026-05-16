#!/usr/bin/env bash
# Shared helpers for river-next update scripts.
#
# current_rev <nix-file>
#   Returns the first `rev` value found in the file.
current_rev() {
  local file="$1"
  sed -n 's/.*rev = "\([^"]*\)".*/\1/p' "$file" | head -n1
}

# prefetch_field <prefetch-json> <field>
#   Extracts a field from the nix-prefetch-git JSON result.
prefetch_field() {
  local prefetch_json="$1" field="$2"
  jq -r ".$field" <<< "$prefetch_json"
}

zon_digest() {
  local zon_file="$1"
  sha256sum "$zon_file" | cut -d' ' -f1
}

current_zon_digest() {
  local zon_nix_file="$1"
  sed -n 's/^# build\.zig\.zon-sha256: //p' "$zon_nix_file" | head -n1
}

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
# update_src <nix-file> <new-rev> <new-hash> <date>
#   Replaces the package's version with the new date.
#   Replaces the `rev` string and the `hash` that immediately follows it in
#   the same fetchFrom block, without touching any other hash fields in the file
#   (e.g. overrideAttrs blocks such as libxkbcommon or meson overrides).
update_src() {
  local file="$1" rev="$2" hash="$3" date="$4"
  ed -s "$file" <<EOF
    /version = "unstable-/s|unstable-[^"]*|unstable-$date|
    /src = fetchFrom[^ ]* {/
    /rev = /s|rev = "[^"]*"|rev = "$rev"|
    /hash = /s|hash = "[^"]*"|hash = "$hash"|
    w
    q
EOF
}

# update_zig_package <repo-url> <ref> <nix-file> <build.zig.zon.nix> <label>
#   Reuses the prefetched source tree to read build.zig.zon. The generated nix
#   file stores the source manifest digest so zon2nix only runs when
#   dependencies actually changed.
update_zig_package() {
  local repo_url="$1" ref="$2" nix_file="$3" zon_nix_file="$4" label="$5"
  local prefetch latest_rev latest_hash latest_path latest_date latest_zon latest_zon_digest current_pkg_rev

  prefetch=$(nix-prefetch-git --url "$repo_url" --rev "$ref") || return 1
  latest_rev=$(prefetch_field "$prefetch" rev)
  latest_hash=$(prefetch_field "$prefetch" hash)
  latest_path=$(prefetch_field "$prefetch" path)
  latest_date=$(prefetch_field "$prefetch" date | sed 's/T.*//')
  latest_zon="$latest_path/build.zig.zon"
  latest_zon_digest=$(zon_digest "$latest_zon")
  current_pkg_rev=$(current_rev "$nix_file")

  if [ ! -f "$latest_zon" ]; then
    echo "$label: missing build.zig.zon in prefetched source tree" >&2
    return 1
  fi

  if [ "$current_pkg_rev" = "$latest_rev" ] && [ -s "$zon_nix_file" ]; then
    echo "$label already at $latest_rev; skipping."
    return 0
  fi

  if [ -s "$zon_nix_file" ] && [ "$(current_zon_digest "$zon_nix_file")" = "$latest_zon_digest" ]; then
    echo "$label build.zig.zon unchanged; skipping dependency regeneration."
    update_src "$nix_file" "$latest_rev" "$latest_hash" "$latest_date"
    return 0
  fi

  zon2nix "$latest_zon" > "$zon_nix_file" || return 1
  write_zon_digest_comment "$zon_nix_file" "$latest_zon_digest" || return 1
  sed -i 's|url = "\(https://[^"?]*\)?ref=[^"]*"|url = "\1"|g' "$zon_nix_file"
  nixfmt "$zon_nix_file"
  update_src "$nix_file" "$latest_rev" "$latest_hash" "$latest_date"
}

# update_other_package <repo-url> <ref> <nix-file> <label>
#   Reuses the prefetched source tree to read information such as rev, hash...
#   Only runs when the package revision actually changes.
update_other_package() {
  local repo_url="$1" ref="$2" nix_file="$3" label="$4"
  local prefetch latest_rev latest_hash latest_date current_pkg_rev

  prefetch=$(nix-prefetch-git --url "$repo_url" --rev "$ref") || return 1
  latest_rev=$(prefetch_field "$prefetch" rev)
  latest_hash=$(prefetch_field "$prefetch" hash)
  latest_date=$(prefetch_field "$prefetch" date | sed 's/T.*//')
  current_pkg_rev=$(current_rev "$nix_file")

  if [ "$current_pkg_rev" = "$latest_rev" ]; then
      echo "$label already at $latest_rev; skipping."
      return 0
  fi

  update_src "$nix_file" "$latest_rev" "$latest_hash" "$latest_date"

}
