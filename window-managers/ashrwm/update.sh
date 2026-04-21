#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts git nix nix-prefetch-git jq nixfmt wget

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

latest_rev=$(git ls-remote https://github.com/shadowash8/ashrwm refs/heads/main | cut -f1)
hash=$(nix-prefetch-git --url https://github.com/shadowash8/ashrwm --rev "$latest_rev" | jq -r '.hash')

source "$SCRIPT_DIR/../update-lib.sh"
update_src "$SCRIPT_DIR/package.nix" "$latest_rev" "$hash"

wget "https://raw.githubusercontent.com/shadowash8/ashrwm/${latest_rev}/build.zig.zon" -O "$SCRIPT_DIR/build.zig.zon"

fetch() {
  local url=$1 rev=$2
  nix-prefetch-git --url "$url" --rev "$rev" 2>/dev/null | jq -r '.hash'
}

fetch_zip() {
  nix hash convert --hash-algo sha256 --to sri "$(nix-prefetch-url --type sha256 --unpack "$1" 2>/dev/null)"
}

wayland_upstream=$(fetch https://gitlab.freedesktop.org/wayland/wayland.git 99638501a1314e68c79176fa2cafa3bbe6cf55ea)
janet_upstream=$(fetch https://github.com/janet-lang/janet 1449ad8b31947999b2b6887fe633883106e5e65c)
xkbcommon_upstream=$(fetch https://github.com/xkbcommon/libxkbcommon.git 0f9cefb1fedb23433666fa5d9045e48ff030c006)

janet=$(fetch https://codeberg.org/ifreund/zig-janet 977e2777b9f0f6fd3531bec3c96c7073b690cbe3)
janet_wayland=$(fetch https://codeberg.org/ifreund/janet-wayland 0aea1ae8c2b462d609fc739acceeb9ead315c07f)
wayland=$(fetch https://github.com/ifreund/wayland-build.zig 8c7f2c42ab0e4c16853d03914ce1f3259cda40db)
libxkbcommon=$(fetch https://github.com/allyourcodebase/libxkbcommon 809157d5118909298f3e086fa8d8103198e938fd)
janet_xkbcommon=$(fetch https://codeberg.org/ifreund/janet-xkbcommon bdd15cd20329078e47abb30bddddfb7b28f52f66)
spork=$(fetch https://github.com/janet-lang/spork 4224d5678ec8bb8777a9075030cf38da52f2d70a)
lemongrass=$(fetch https://github.com/pyrmont/lemongrass 906974b82ba06ed421e0c8cd9a56c6ddc4ca6820)
river=$(fetch https://codeberg.org/river/river addd4a0c5386fe3efc6d37cdde458d0f3153bebe)
wayland_protocols=$(fetch https://gitlab.freedesktop.org/wayland/wayland-protocols 02e63e74a807afed95bc25a386173110afef24e3)
pixman=$(fetch_zip https://codeberg.org/ifreund/zig-pixman/archive/v0.3.0.tar.gz)
wayland_legacy=$(fetch_zip https://codeberg.org/ifreund/zig-wayland/archive/v0.5.0.tar.gz)
wlroots=$(fetch_zip https://codeberg.org/ifreund/zig-wlroots/archive/v0.20.0.tar.gz)
xkbcommon_legacy=$(fetch_zip https://codeberg.org/ifreund/zig-xkbcommon/archive/v0.4.0.tar.gz)

cat > "$SCRIPT_DIR/build.zig.zon.nix" << EOF
{ linkFarm, fetchgit, fetchzip }:
linkFarm "zig-packages" [
  { name = "N-V-__8AAEZXGQD2FnVezv2mY8V4aYW9j-JDCLw6vDmFFqze";
    path = fetchgit { url = "https://gitlab.freedesktop.org/wayland/wayland.git"; rev = "99638501a1314e68c79176fa2cafa3bbe6cf55ea"; hash = "$wayland_upstream"; }; }
  { name = "N-V-__8AAIEhIgBR5OJUsRfe9z01OzwIngIwNeZy1NBuBEoc";
    path = fetchgit { url = "https://github.com/janet-lang/janet"; rev = "1449ad8b31947999b2b6887fe633883106e5e65c"; hash = "$janet_upstream"; }; }
  { name = "N-V-__8AAFRAZAD02nId1w02lyWXmN-hvo873BSh9wZDxjSN";
    path = fetchgit { url = "https://github.com/xkbcommon/libxkbcommon.git"; rev = "0f9cefb1fedb23433666fa5d9045e48ff030c006"; hash = "$xkbcommon_upstream"; }; }
  { name = "janet-1.40.1-3XUN8cVGAAA7Os-UamOhi0sYVRqN-slGltgD5Jwwwfdk";
    path = fetchgit { url = "https://codeberg.org/ifreund/zig-janet"; rev = "977e2777b9f0f6fd3531bec3c96c7073b690cbe3"; hash = "$janet"; }; }
  { name = "N-V-__8AAFKzAADGCCHsA4J38ww-aT3CFoj2MbSxtkWX0D50";
    path = fetchgit { url = "https://codeberg.org/ifreund/janet-wayland"; rev = "0aea1ae8c2b462d609fc739acceeb9ead315c07f"; hash = "$janet_wayland"; }; }
  { name = "wayland-1.24.0-3-dxEBa1pmAABlHkqXCGmZ4r9c_N8fhAXculLHBbO2pRRT";
    path = fetchgit { url = "https://github.com/ifreund/wayland-build.zig"; rev = "8c7f2c42ab0e4c16853d03914ce1f3259cda40db"; hash = "$wayland"; }; }
  { name = "libxkbcommon-1.11.0-1-93LaF6pwAgDFoaLfOkR8ioG4RVcDHbBhsDmC_rYwyOEG";
    path = fetchgit { url = "https://github.com/allyourcodebase/libxkbcommon"; rev = "809157d5118909298f3e086fa8d8103198e938fd"; hash = "$libxkbcommon"; }; }
  { name = "N-V-__8AAGELAABqy7_LKHe7k7pcmtqO8MJth7xoJZSYvriG";
    path = fetchgit { url = "https://codeberg.org/ifreund/janet-xkbcommon"; rev = "bdd15cd20329078e47abb30bddddfb7b28f52f66"; hash = "$janet_xkbcommon"; }; }
  { name = "N-V-__8AAA3IEACRX8ha9Z5HVJLPzBt9S6Kt7oNfQsWh5vUN";
    path = fetchgit { url = "https://github.com/janet-lang/spork"; rev = "4224d5678ec8bb8777a9075030cf38da52f2d70a"; hash = "$spork"; }; }
  { name = "N-V-__8AAPMqAQCbXJ9KGZ7pEepOFcJFiLb-PW0LlAOhlgtd";
    path = fetchgit { url = "https://github.com/pyrmont/lemongrass"; rev = "906974b82ba06ed421e0c8cd9a56c6ddc4ca6820"; hash = "$lemongrass"; }; }
  { name = "river-0.4.2-_G6Njq3eCwBPOoLbZB7ULNNEcIFDNJpz-vDYzr6JanWZ";
    path = fetchgit { url = "https://codeberg.org/river/river"; rev = "addd4a0c5386fe3efc6d37cdde458d0f3153bebe"; hash = "$river"; }; }
  { name = "N-V-__8AAMCWEADA0AS-1LfBEtixZLJAb_XQKQpgSmR2uxAO";
    path = fetchgit { url = "https://gitlab.freedesktop.org/wayland/wayland-protocols"; rev = "02e63e74a807afed95bc25a386173110afef24e3"; hash = "$wayland_protocols"; }; }
  { name = "pixman-0.3.0-LClMnz2VAAAs7QSCGwLimV5VUYx0JFnX5xWU6HwtMuDX";
    path = fetchzip { url = "https://codeberg.org/ifreund/zig-pixman/archive/v0.3.0.tar.gz"; hash = "$pixman"; }; }
  { name = "wayland-0.5.0-lQa1knz8AQCh08NA8BeQrwJB9U3CfqcVAdHZYGRKIGuu";
    path = fetchzip { url = "https://codeberg.org/ifreund/zig-wayland/archive/v0.5.0.tar.gz"; hash = "$wayland_legacy"; }; }
  { name = "wlroots-0.20.0-jmOlcmtCBADS6eoJ6mkeiSNZkibrhD-c5Qwn-LiM86r1";
    path = fetchzip { url = "https://codeberg.org/ifreund/zig-wlroots/archive/v0.20.0.tar.gz"; hash = "$wlroots"; }; }
  { name = "xkbcommon-0.4.0-VDqIe0i2AgDRsok2GpMFYJ8SVhQS10_PI2M_CnHXsJJZ";
    path = fetchzip { url = "https://codeberg.org/ifreund/zig-xkbcommon/archive/v0.4.0.tar.gz"; hash = "$xkbcommon_legacy"; }; }
]
EOF

nixfmt "$SCRIPT_DIR/build.zig.zon.nix"

rm -f "$SCRIPT_DIR/build.zig.zon"
