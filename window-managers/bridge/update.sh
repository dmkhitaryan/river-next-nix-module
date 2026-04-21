#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts git nix nix-prefetch-git jq nixfmt wget

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

latest_rev=$(git ls-remote https://codeberg.org/sunn4room/bridge refs/heads/main | cut -f1)
hash=$(nix-prefetch-git --url https://codeberg.org/sunn4room/bridge --rev "$latest_rev" | jq -r '.hash')

source "$SCRIPT_DIR/../update-lib.sh"
update_src "$SCRIPT_DIR/package.nix" "$latest_rev" "$hash"

wget "https://codeberg.org/sunn4room/bridge/raw/commit/${latest_rev}/build.zig.zon" -O "$SCRIPT_DIR/build.zig.zon"

fetch_zip() {
  nix hash convert --hash-algo sha256 --to sri "$(nix-prefetch-url --type sha256 --unpack "$1" 2>/dev/null)"
}

wayland=$(fetch_zip https://codeberg.org/ifreund/zig-wayland/archive/v0.5.0.tar.gz)
river=$(fetch_zip https://codeberg.org/river/river/archive/v0.4.1.tar.gz)
xkbcommon=$(fetch_zip https://codeberg.org/ifreund/zig-xkbcommon/archive/v0.4.0.tar.gz)
wayland_protocols=$(fetch_zip https://gitlab.freedesktop.org/wayland/wayland-protocols/-/archive/1.47/wayland-protocols-1.47.tar.gz)
pixman=$(fetch_zip https://codeberg.org/ifreund/zig-pixman/archive/v0.3.0.tar.gz)
wlroots=$(fetch_zip https://codeberg.org/ifreund/zig-wlroots/archive/v0.19.4.tar.gz)
fcft=$(fetch_zip https://git.sr.ht/~novakane/zig-fcft/archive/v3.0.0.tar.gz)

cat > "$SCRIPT_DIR/build.zig.zon.nix" << EOF
{ linkFarm, fetchzip }:
linkFarm "zig-packages" [
  { name = "wayland-0.5.0-lQa1knz8AQCh08NA8BeQrwJB9U3CfqcVAdHZYGRKIGuu";
    path = fetchzip { url = "https://codeberg.org/ifreund/zig-wayland/archive/v0.5.0.tar.gz"; hash = "$wayland"; }; }
  { name = "river-0.4.1-_G6Njv-nCwBebH8tw6eZ3ERv05GLjVkzpFzRGsnpfzgG";
    path = fetchzip { url = "https://codeberg.org/river/river/archive/v0.4.1.tar.gz"; hash = "$river"; }; }
  { name = "xkbcommon-0.4.0-VDqIe0i2AgDRsok2GpMFYJ8SVhQS10_PI2M_CnHXsJJZ";
    path = fetchzip { url = "https://codeberg.org/ifreund/zig-xkbcommon/archive/v0.4.0.tar.gz"; hash = "$xkbcommon"; }; }
  { name = "N-V-__8AAFdWDwA0ktbNUi9pFBHCRN4weXIgIfCrVjfGxqgA";
    path = fetchzip { url = "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/archive/1.47/wayland-protocols-1.47.tar.gz"; hash = "$wayland_protocols"; }; }
  { name = "pixman-0.3.0-LClMnz2VAAAs7QSCGwLimV5VUYx0JFnX5xWU6HwtMuDX";
    path = fetchzip { url = "https://codeberg.org/ifreund/zig-pixman/archive/v0.3.0.tar.gz"; hash = "$pixman"; }; }
  { name = "wlroots-0.19.4-jmOlcqQMBABhKYH6NMSnoK1sohTbhc97_JP-hGg2UZaK";
    path = fetchzip { url = "https://codeberg.org/ifreund/zig-wlroots/archive/v0.19.4.tar.gz"; hash = "$wlroots"; }; }
  { name = "fcft-3.0.0-zcx6CxQfAAAOlHFehXv7HwRPcuo7StCjZAtapZbSB6fq";
    path = fetchzip { url = "https://git.sr.ht/~novakane/zig-fcft/archive/v3.0.0.tar.gz"; hash = "$fcft"; }; }
]
EOF

nixfmt "$SCRIPT_DIR/build.zig.zon.nix"

rm -f "$SCRIPT_DIR/build.zig.zon"
