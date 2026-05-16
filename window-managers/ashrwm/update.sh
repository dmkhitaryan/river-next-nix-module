#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts git nix nix-prefetch-git jq nixfmt ed

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR" || exit 1

source ../update-lib.sh

prefetch=$(nix-prefetch-git --url https://github.com/shadowash8/ashrwm --rev refs/heads/main)
latest_rev=$(prefetch_field "$prefetch" rev)
latest_hash=$(prefetch_field "$prefetch" hash)
latest_date=$(prefetch_field "$prefetch" date | sed 's/T.*//')
latest_path=$(prefetch_field "$prefetch" path)
latest_zon="$latest_path/build.zig.zon"
latest_zon_digest=$(zon_digest "$latest_zon")
current_pkg_rev=$(current_rev package.nix)

if [ "$current_pkg_rev" = "$latest_rev" ] && [ -s build.zig.zon.nix ]; then
  echo "ashrwm already at $latest_rev; skipping."
  exit 0
fi

if [ -s build.zig.zon.nix ] && [ "$(current_zon_digest build.zig.zon.nix)" = "$latest_zon_digest" ]; then
  echo "ashrwm build.zig.zon unchanged; skipping dependency regeneration."
  update_src package.nix "$latest_rev" "$latest_hash" "$latest_date"
  exit 0
fi

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

janet=$(fetch https://codeberg.org/shadowash8/zig-janet 638d8d204d0bf52291016389fa6102f9c65a1165)
janet_wayland=$(fetch https://codeberg.org/ifreund/janet-wayland 0aea1ae8c2b462d609fc739acceeb9ead315c07f)
wayland_upstream_1_25=$(fetch https://gitlab.freedesktop.org/wayland/wayland.git 3e673a438b0a9749e3bdf5cac4befac86333024c)
wayland=$(fetch https://github.com/shadowash8/wayland-build.zig 4f52f0c5ef51de908b1797683f029d5260b03aaf)
libxkbcommon=$(fetch https://github.com/allyourcodebase/libxkbcommon 8c31126430bec39d2cb5f06aa3c2667e006b32ea)
xkbcommon_upstream_1_13=$(fetch https://github.com/xkbcommon/libxkbcommon.git 6f76d19db72b5d450e927b41e1e96cbe3252aba8)
janet_xkbcommon=$(fetch https://codeberg.org/ifreund/janet-xkbcommon bdd15cd20329078e47abb30bddddfb7b28f52f66)
spork=$(fetch https://github.com/janet-lang/spork 4224d5678ec8bb8777a9075030cf38da52f2d70a)
lemongrass=$(fetch https://github.com/pyrmont/lemongrass 906974b82ba06ed421e0c8cd9a56c6ddc4ca6820)
aro=$(fetch https://github.com/Vexu/arocc 5f5a050569a95ecc40a426f0c3666ae7ef987ede)
translate_c=$(fetch https://codeberg.org/ziglang/translate-c/ 57c559cf581b1fcad90494eda219f98abeb155ce)
river=$(fetch https://codeberg.org/river/river f6d961773711dc29d3eb5b60bd14744a6a33894f)
wayland_protocols=$(fetch https://gitlab.freedesktop.org/wayland/wayland-protocols 02e63e74a807afed95bc25a386173110afef24e3)
libexpat=$(fetch https://github.com/allyourcodebase/libexpat.git 662b7d1cb5f347598d4619d125be317cc2c52b62)
libexpat_upstream=$(fetch https://github.com/libexpat/libexpat f9a3eeb3e09fbea04b1c451ffc422ab2f1e45744)
libffi=$(fetch https://codeberg.org/vezel/libffi 74386f41b576e6e33253f9c46ea781764b84f536)
libxml2=$(fetch https://github.com/allyourcodebase/libxml2.git 2528fad1bf17a0a70999930cfd9280554f547787)
libxml2_upstream=$(fetch_zip https://download.gnome.org/sources/libxml2/2.15/libxml2-2.15.1.tar.xz)
zlib=$(fetch https://github.com/allyourcodebase/zlib.git c5115f4b69ef660f72a835c6638f80508ef284c7)
zlib_upstream=$(fetch_zip https://github.com/madler/zlib/archive/refs/tags/v1.3.1.tar.gz)
libiconv=$(fetch https://github.com/allyourcodebase/libiconv.git d86666233f4e0045b586060260e8a6093f5cdd8d)
libiconv_upstream=$(fetch_zip https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.18.tar.gz)
win_iconv=$(fetch https://github.com/allyourcodebase/win-iconv.git 341e958b33f1cd1142f00a561510d83e6556f1fd)
win_iconv_upstream=$(fetch https://github.com/win-iconv/win-iconv 82f00fbc1b1156530a0bbd003b93b3942743ed27)
epoll_shim=$(fetch https://github.com/jiixyj/epoll-shim.git 18159584bb3d17e601b9315a7398ace018251bdc)
pixman=$(fetch_zip https://codeberg.org/ifreund/zig-pixman/archive/v0.3.0.tar.gz)
wayland_modern=$(fetch_zip https://codeberg.org/ifreund/zig-wayland/archive/v0.6.0.tar.gz)
wayland_legacy=$(fetch_zip https://codeberg.org/ifreund/zig-wayland/archive/v0.5.0.tar.gz)
wlroots=$(fetch_zip https://codeberg.org/ifreund/zig-wlroots/archive/v0.20.0.tar.gz)
wlroots_modern=$(fetch_zip https://codeberg.org/ifreund/zig-wlroots/archive/v0.20.1.tar.gz)
xkbcommon_legacy=$(fetch_zip https://codeberg.org/ifreund/zig-xkbcommon/archive/v0.4.0.tar.gz)

cat > build.zig.zon.nix << EOF
{ linkFarm, fetchgit, fetchzip }:
linkFarm "zig-packages" [
  { name = "N-V-__8AAEZXGQD2FnVezv2mY8V4aYW9j-JDCLw6vDmFFqze";
    path = fetchgit { url = "https://gitlab.freedesktop.org/wayland/wayland.git"; rev = "99638501a1314e68c79176fa2cafa3bbe6cf55ea"; hash = "$wayland_upstream"; }; }
  { name = "N-V-__8AAIEhIgBR5OJUsRfe9z01OzwIngIwNeZy1NBuBEoc";
    path = fetchgit { url = "https://github.com/janet-lang/janet"; rev = "1449ad8b31947999b2b6887fe633883106e5e65c"; hash = "$janet_upstream"; }; }
  { name = "N-V-__8AAFRAZAD02nId1w02lyWXmN-hvo873BSh9wZDxjSN";
    path = fetchgit { url = "https://github.com/xkbcommon/libxkbcommon.git"; rev = "0f9cefb1fedb23433666fa5d9045e48ff030c006"; hash = "$xkbcommon_upstream"; }; }
  { name = "janet-1.40.1-3XUN8XBHAACHFw6WZRjSbJ0BjX27rXCUvQKat43iHXgA";
    path = fetchgit { url = "https://codeberg.org/shadowash8/zig-janet"; rev = "638d8d204d0bf52291016389fa6102f9c65a1165"; hash = "$janet"; }; }
  { name = "N-V-__8AAFKzAADGCCHsA4J38ww-aT3CFoj2MbSxtkWX0D50";
    path = fetchgit { url = "https://codeberg.org/ifreund/janet-wayland"; rev = "0aea1ae8c2b462d609fc739acceeb9ead315c07f"; hash = "$janet_wayland"; }; }
  { name = "N-V-__8AAHn0JAAOBkhzH_lP16r6zcK9R4FIAKGhA7Fdc7gD";
    path = fetchgit { url = "https://gitlab.freedesktop.org/wayland/wayland.git"; rev = "3e673a438b0a9749e3bdf5cac4befac86333024c"; hash = "$wayland_upstream_1_25"; }; }
  { name = "wayland-1.25.0-dxEBa-F8AABPX6jLWqVIso2VnrD-M_qAmdSPQxLaVZvL";
    path = fetchgit { url = "https://github.com/shadowash8/wayland-build.zig"; rev = "4f52f0c5ef51de908b1797683f029d5260b03aaf"; hash = "$wayland"; }; }
  { name = "libxkbcommon-1.13.1-93LaF2x7AgDgSrr8xjRYrYGhtGhJKcZMuID3M95APvl1";
    path = fetchgit { url = "https://github.com/allyourcodebase/libxkbcommon"; rev = "8c31126430bec39d2cb5f06aa3c2667e006b32ea"; hash = "$libxkbcommon"; }; }
  { name = "N-V-__8AALGdawC4U4VZt8pBwXK8gBVv2OTdm2naBwU9xHcb";
    path = fetchgit { url = "https://github.com/xkbcommon/libxkbcommon.git"; rev = "6f76d19db72b5d450e927b41e1e96cbe3252aba8"; hash = "$xkbcommon_upstream_1_13"; }; }
  { name = "N-V-__8AAGELAABqy7_LKHe7k7pcmtqO8MJth7xoJZSYvriG";
    path = fetchgit { url = "https://codeberg.org/ifreund/janet-xkbcommon"; rev = "bdd15cd20329078e47abb30bddddfb7b28f52f66"; hash = "$janet_xkbcommon"; }; }
  { name = "N-V-__8AAA3IEACRX8ha9Z5HVJLPzBt9S6Kt7oNfQsWh5vUN";
    path = fetchgit { url = "https://github.com/janet-lang/spork"; rev = "4224d5678ec8bb8777a9075030cf38da52f2d70a"; hash = "$spork"; }; }
  { name = "N-V-__8AAPMqAQCbXJ9KGZ7pEepOFcJFiLb-PW0LlAOhlgtd";
    path = fetchgit { url = "https://github.com/pyrmont/lemongrass"; rev = "906974b82ba06ed421e0c8cd9a56c6ddc4ca6820"; hash = "$lemongrass"; }; }
  { name = "aro-0.0.0-JSD1Qi7QNgDnfcrdEJf82v3o6MhZySjYVrtdfEf3E4Se";
    path = fetchgit { url = "https://github.com/Vexu/arocc"; rev = "5f5a050569a95ecc40a426f0c3666ae7ef987ede"; hash = "$aro"; }; }
  { name = "translate_c-0.0.0-Q_BUWlX1BgCD1wo6uo97prlp9VJ4gxAjwN_vZ7nsSjGN";
    path = fetchgit { url = "https://codeberg.org/ziglang/translate-c/"; rev = "57c559cf581b1fcad90494eda219f98abeb155ce"; hash = "$translate_c"; }; }
  { name = "river-0.4.5-_G6Njt6_CwB4aHyFxnYjZq2_hQLBK4iJd4MkvgWF6RZm";
    path = fetchgit { url = "https://codeberg.org/river/river"; rev = "f6d961773711dc29d3eb5b60bd14744a6a33894f"; hash = "$river"; }; }
  { name = "N-V-__8AAMCWEADA0AS-1LfBEtixZLJAb_XQKQpgSmR2uxAO";
    path = fetchgit { url = "https://gitlab.freedesktop.org/wayland/wayland-protocols"; rev = "02e63e74a807afed95bc25a386173110afef24e3"; hash = "$wayland_protocols"; }; }
  { name = "pixman-0.3.0-LClMnz2VAAAs7QSCGwLimV5VUYx0JFnX5xWU6HwtMuDX";
    path = fetchzip { url = "https://codeberg.org/ifreund/zig-pixman/archive/v0.3.0.tar.gz"; hash = "$pixman"; }; }
  { name = "wayland-0.6.0-lQa1kqz8AQADQmdNJsNhLoNHcnEGEUjrOaPV-dtEnEmX";
    path = fetchzip { url = "https://codeberg.org/ifreund/zig-wayland/archive/v0.6.0.tar.gz"; hash = "$wayland_modern"; }; }
  { name = "wayland-0.5.0-lQa1knz8AQCh08NA8BeQrwJB9U3CfqcVAdHZYGRKIGuu";
    path = fetchzip { url = "https://codeberg.org/ifreund/zig-wayland/archive/v0.5.0.tar.gz"; hash = "$wayland_legacy"; }; }
  { name = "wlroots-0.20.0-jmOlcmtCBADS6eoJ6mkeiSNZkibrhD-c5Qwn-LiM86r1";
    path = fetchzip { url = "https://codeberg.org/ifreund/zig-wlroots/archive/v0.20.0.tar.gz"; hash = "$wlroots"; }; }
  { name = "wlroots-0.20.1-jmOlcqNVBAB3uB5oqBTzpRlwu-FmMyyZMVAWCe5kmcSt";
    path = fetchzip { url = "https://codeberg.org/ifreund/zig-wlroots/archive/v0.20.1.tar.gz"; hash = "$wlroots_modern"; }; }
  { name = "xkbcommon-0.4.0-VDqIe0i2AgDRsok2GpMFYJ8SVhQS10_PI2M_CnHXsJJZ";
    path = fetchzip { url = "https://codeberg.org/ifreund/zig-xkbcommon/archive/v0.4.0.tar.gz"; hash = "$xkbcommon_legacy"; }; }
  { name = "libexpat-2.7.1-3-y_akI_s7AABtuMADtwTTJGOxx8iY5ZC9T8EON6cjvbNw";
    path = fetchgit { url = "https://github.com/allyourcodebase/libexpat.git"; rev = "662b7d1cb5f347598d4619d125be317cc2c52b62"; hash = "$libexpat"; }; }
  { name = "libffi-3.5.2-7_tEtAQ6FwD6zfnc_i2bMJ3JgNr8YkgrBa1A8TWL39GC";
    path = fetchgit { url = "https://codeberg.org/vezel/libffi"; rev = "74386f41b576e6e33253f9c46ea781764b84f536"; hash = "$libffi"; }; }
  { name = "libxml2-2.15.1-2-qHdjhmNMAAAiZOWqVridicq2oMf5NHv0n9W41bz9FtMM";
    path = fetchgit { url = "https://github.com/allyourcodebase/libxml2.git"; rev = "2528fad1bf17a0a70999930cfd9280554f547787"; hash = "$libxml2"; }; }
  { name = "N-V-__8AAMX2GwiF4I3vxSUHX70z0UP4G2EwLiT2Q9eNGkwN";
    path = fetchgit { url = "https://github.com/libexpat/libexpat"; rev = "f9a3eeb3e09fbea04b1c451ffc422ab2f1e45744"; hash = "$libexpat_upstream"; }; }
  { name = "N-V-__8AAPCbSwEcttmGC8VZFtoJxaP06X_upd7O13NMUkIf";
    path = fetchzip { url = "https://download.gnome.org/sources/libxml2/2.15/libxml2-2.15.1.tar.xz"; hash = "$libxml2_upstream"; }; }
  { name = "zlib-1.3.1-1-ZZQ7ldENAAA7qJjUXP6E6xnRuV-jDL9dyoJFc_eb3zQ6";
    path = fetchgit { url = "https://github.com/allyourcodebase/zlib.git"; rev = "c5115f4b69ef660f72a835c6638f80508ef284c7"; hash = "$zlib"; }; }
  { name = "libiconv-1.18.0-p9sJwWnqAAAAD_T5JHJ8v9OrgUtLGT6ov322zOnkUkv5";
    path = fetchgit { url = "https://github.com/allyourcodebase/libiconv.git"; rev = "d86666233f4e0045b586060260e8a6093f5cdd8d"; hash = "$libiconv"; }; }
  { name = "win_iconv-0.0.10--19NP7MRAAAnmImNeW9llGV-UPmCHV-4MN_FVzNhb-P0";
    path = fetchgit { url = "https://github.com/allyourcodebase/win-iconv.git"; rev = "341e958b33f1cd1142f00a561510d83e6556f1fd"; hash = "$win_iconv"; }; }
  { name = "N-V-__8AAANWAQBoiCxdwbAmaA0PDpYKI0zfFJ1Woy67Tjh2";
    path = fetchgit { url = "https://github.com/win-iconv/win-iconv"; rev = "82f00fbc1b1156530a0bbd003b93b3942743ed27"; hash = "$win_iconv_upstream"; }; }
  { name = "N-V-__8AAFwJUgGJcIFZ3fj0Q9U_KtvhHdZXlLz1FcAuIcmX";
    path = fetchzip { url = "https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.18.tar.gz"; hash = "$libiconv_upstream"; }; }
  { name = "N-V-__8AAB0eQwD-0MdOEBmz7intriBReIsIDNlukNVoNu6o";
    path = fetchzip { url = "https://github.com/madler/zlib/archive/refs/tags/v1.3.1.tar.gz"; hash = "$zlib_upstream"; }; }
  { name = "N-V-__8AAJHtBwDe4gR5ofaikfFsHj0vPE-uTQSAkqY2uRv_";
    path = fetchgit { url = "https://github.com/jiixyj/epoll-shim.git"; rev = "18159584bb3d17e601b9315a7398ace018251bdc"; hash = "$epoll_shim"; }; }
]
EOF

write_zon_digest_comment build.zig.zon.nix "$latest_zon_digest"
nixfmt build.zig.zon.nix
update_src package.nix "$latest_rev" "$latest_hash" "$latest_date"
