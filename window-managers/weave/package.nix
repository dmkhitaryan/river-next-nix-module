{
  lib,
  stdenv,
  fetchFromCodeberg,
  wayland,
  pkg-config,
  wayland-scanner,
  libxkbcommon,
  vali,
  meson,
  ninja,
  wayland-protocols,
  tomlplusplus,
  libevdev,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "weave";
  version = "unstable-2026-10-05";

  src = fetchFromCodeberg {
    owner = "natthias";
    repo = "weave";
    rev = "6e6d763b7611b4aac99fc6159cdb549f82da8630";
    hash = "sha256-Kap1rQsKWaXtSK04+V5K7SEuOgLcRRRmM0DQO3u5OEE=";
  };

  nativeBuildInputs = [
    meson
    wayland-scanner
    pkg-config
    ninja
  ];

  buildInputs = [
    wayland
    libxkbcommon
    wayland-protocols
    tomlplusplus
    vali
    libevdev
  ];

  postPatch = ''
    sed -i '1i#include <cstdint>' src/common/include/util.hh
    sed -i '1i#include <memory>' src/weavectl/main.cc
    sed -i '1i#include <array>' src/weave/Weave.hh
    sed -i '1i#include <cstdint>\n#include <optional>\n#include <utility>' src/weave/WindowRule.hh
    sed -i '1i#include <optional>' src/weave/Window.hh

    substituteInPlace src/weave/Weave.hh \
      --replace-fail \
      'static const varlink_handler varlink_handler;' \
      'static const struct varlink_handler varlink_handler;'

    substituteInPlace src/common/include/util.hh \
      --replace-fail '#include <xkbcommon/xkbcommon.h>' \
                     $'#include <optional>\n#include <xkbcommon/xkbcommon.h>'
  '';

  meta = {
    homepage = "https://codeberg.org/natthias/weave";
    description = "Dynamic tiling window manager configured through TOML.";
    license = with lib.licenses; [
      bsd3
      mit
    ];
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
