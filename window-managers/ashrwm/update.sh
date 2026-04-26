#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts nix nix-prefetch-git jq nixfmt

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR" || exit 1

source ../update-lib.sh

latest_tag=$(list-git-tags --url=https://github.com/shadowash8/ashrwm | sed 's/^v//' | sort --version-sort | tail --lines=1)
prefetch=$(nix-prefetch-git --url https://github.com/shadowash8/ashrwm --rev "v$latest_tag")
hash=$(prefetch_field "$prefetch" hash)
latest_path=$(prefetch_field "$prefetch" path)
latest_zon="$latest_path/build.zig.zon"
latest_zon_digest=$(zon_digest "$latest_zon")

if [ -s build.zig.zon.nix ] && [ "$(current_zon_digest build.zig.zon.nix)" = "$latest_zon_digest" ]; then
  echo "ashrwm build.zig.zon unchanged; skipping dependency regeneration."
  update_src package.nix "$latest_tag" "$hash"
  exit 0
fi

fetch() {
  local url=$1 rev=$2
  nix-prefetch-git --url "$url" --rev "$rev" 2>/dev/null | jq -r '.hash'
}

janet=$(fetch https://codeberg.org/ifreund/zig-janet 977e2777b9f0f6fd3531bec3c96c7073b690cbe3)
janet_wayland=$(fetch https://codeberg.org/ifreund/janet-wayland c118af389f43ac853c5189db4fd5cc430c7a3370)
fetch_zip() {
  nix hash to-sri --type sha256 "$(nix-prefetch-url --type sha256 --unpack "$1" 2>/dev/null)"
}
wayland_upstream=$(fetch https://gitlab.freedesktop.org/wayland/wayland.git 99638501a1314e68c79176fa2cafa3bbe6cf55ea)
janet_upstream=$(fetch https://github.com/janet-lang/janet 1449ad8b31947999b2b6887fe633883106e5e65c)
wayland=$(fetch https://github.com/ifreund/wayland-build.zig 8c7f2c42ab0e4c16853d03914ce1f3259cda40db)
xkbcommon_upstream=$(fetch https://github.com/xkbcommon/libxkbcommon.git 0f9cefb1fedb23433666fa5d9045e48ff030c006)
libxkbcommon=$(fetch https://github.com/allyourcodebase/libxkbcommon 809157d5118909298f3e086fa8d8103198e938fd)
janet_xkbcommon=$(fetch https://codeberg.org/ifreund/janet-xkbcommon bdd15cd20329078e47abb30bddddfb7b28f52f66)
spork=$(fetch https://github.com/janet-lang/spork 4224d5678ec8bb8777a9075030cf38da52f2d70a)
lemongrass=$(fetch https://github.com/pyrmont/lemongrass 906974b82ba06ed421e0c8cd9a56c6ddc4ca6820)
river=$(fetch https://codeberg.org/river/river 6b9f40ca72dc4be6ef5866fbb78a3464a1941071)
wayland_protocols=$(fetch https://gitlab.freedesktop.org/wayland/wayland-protocols 88223018d1b578d0d8869866da66d9608e05f928)
pixman=$(fetch_zip https://codeberg.org/ifreund/zig-pixman/archive/v0.3.0.tar.gz)
wayland_archive=$(fetch_zip https://codeberg.org/ifreund/zig-wayland/archive/v0.5.0.tar.gz)
wlroots=$(fetch_zip https://codeberg.org/ifreund/zig-wlroots/archive/v0.19.4.tar.gz)
xkbcommon_archive=$(fetch_zip https://codeberg.org/ifreund/zig-xkbcommon/archive/v0.4.0.tar.gz)

cat > build.zig.zon.nix << EOF
{ linkFarm, fetchgit, fetchzip }:
linkFarm "zig-packages" [
  { name = "janet-1.40.1-3XUN8cVGAAA7Os-UamOhi0sYVRqN-slGltgD5Jwwwfdk";
    path = fetchgit { url = "https://codeberg.org/ifreund/zig-janet"; rev = "977e2777b9f0f6fd3531bec3c96c7073b690cbe3"; hash = "$janet"; }; }
  { name = "N-V-__8AAPOoAACNhl0Pd9muOFuvch4kljaImdQiU6FPr9tY";
    path = fetchgit { url = "https://codeberg.org/ifreund/janet-wayland"; rev = "c118af389f43ac853c5189db4fd5cc430c7a3370"; hash = "$janet_wayland"; }; }
  { name = "N-V-__8AAEZXGQD2FnVezv2mY8V4aYW9j-JDCLw6vDmFFqze";
    path = fetchgit { url = "https://gitlab.freedesktop.org/wayland/wayland.git"; rev = "99638501a1314e68c79176fa2cafa3bbe6cf55ea"; hash = "$wayland_upstream"; }; }
  { name = "N-V-__8AAIEhIgBR5OJUsRfe9z01OzwIngIwNeZy1NBuBEoc";
    path = fetchgit { url = "https://github.com/janet-lang/janet"; rev = "1449ad8b31947999b2b6887fe633883106e5e65c"; hash = "$janet_upstream"; }; }
  { name = "wayland-1.24.0-3-dxEBa1pmAABlHkqXCGmZ4r9c_N8fhAXculLHBbO2pRRT";
    path = fetchgit { url = "https://github.com/ifreund/wayland-build.zig"; rev = "8c7f2c42ab0e4c16853d03914ce1f3259cda40db"; hash = "$wayland"; }; }
  { name = "N-V-__8AAFRAZAD02nId1w02lyWXmN-hvo873BSh9wZDxjSN";
    path = fetchgit { url = "https://github.com/xkbcommon/libxkbcommon.git"; rev = "0f9cefb1fedb23433666fa5d9045e48ff030c006"; hash = "$xkbcommon_upstream"; }; }
  { name = "libxkbcommon-1.11.0-1-93LaF6pwAgDFoaLfOkR8ioG4RVcDHbBhsDmC_rYwyOEG";
    path = fetchgit { url = "https://github.com/allyourcodebase/libxkbcommon"; rev = "809157d5118909298f3e086fa8d8103198e938fd"; hash = "$libxkbcommon"; }; }
  { name = "N-V-__8AAGELAABqy7_LKHe7k7pcmtqO8MJth7xoJZSYvriG";
    path = fetchgit { url = "https://codeberg.org/ifreund/janet-xkbcommon"; rev = "bdd15cd20329078e47abb30bddddfb7b28f52f66"; hash = "$janet_xkbcommon"; }; }
  { name = "N-V-__8AAA3IEACRX8ha9Z5HVJLPzBt9S6Kt7oNfQsWh5vUN";
    path = fetchgit { url = "https://github.com/janet-lang/spork"; rev = "4224d5678ec8bb8777a9075030cf38da52f2d70a"; hash = "$spork"; }; }
  { name = "N-V-__8AAPMqAQCbXJ9KGZ7pEepOFcJFiLb-PW0LlAOhlgtd";
    path = fetchgit { url = "https://github.com/pyrmont/lemongrass"; rev = "906974b82ba06ed421e0c8cd9a56c6ddc4ca6820"; hash = "$lemongrass"; }; }
  { name = "river-0.5.0-dev-_G6NjqqiCwBu8xdp2A55txZJQp70Krn21-PEWuMdDwQr";
    path = fetchgit { url = "https://codeberg.org/river/river"; rev = "6b9f40ca72dc4be6ef5866fbb78a3464a1941071"; hash = "$river"; }; }
  { name = "N-V-__8AAFdWDwA0ktbNUi9pFBHCRN4weXIgIfCrVjfGxqgA";
    path = fetchgit { url = "https://gitlab.freedesktop.org/wayland/wayland-protocols"; rev = "88223018d1b578d0d8869866da66d9608e05f928"; hash = "$wayland_protocols"; }; }
  { name = "pixman-0.3.0-LClMnz2VAAAs7QSCGwLimV5VUYx0JFnX5xWU6HwtMuDX";
    path = fetchzip { url = "https://codeberg.org/ifreund/zig-pixman/archive/v0.3.0.tar.gz"; hash = "$pixman"; }; }
  { name = "wayland-0.5.0-lQa1knz8AQCh08NA8BeQrwJB9U3CfqcVAdHZYGRKIGuu";
    path = fetchzip { url = "https://codeberg.org/ifreund/zig-wayland/archive/v0.5.0.tar.gz"; hash = "$wayland_archive"; }; }
  { name = "wlroots-0.19.4-jmOlcqQMBABhKYH6NMSnoK1sohTbhc97_JP-hGg2UZaK";
    path = fetchzip { url = "https://codeberg.org/ifreund/zig-wlroots/archive/v0.19.4.tar.gz"; hash = "$wlroots"; }; }
  { name = "xkbcommon-0.4.0-VDqIe0i2AgDRsok2GpMFYJ8SVhQS10_PI2M_CnHXsJJZ";
    path = fetchzip { url = "https://codeberg.org/ifreund/zig-xkbcommon/archive/v0.4.0.tar.gz"; hash = "$xkbcommon_archive"; }; }
]
EOF

write_zon_digest_comment build.zig.zon.nix "$latest_zon_digest"
nixfmt build.zig.zon.nix
update_src package.nix "$latest_tag" "$hash"
