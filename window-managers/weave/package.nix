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
  version = "unstable-2026-09-28";

  src = fetchFromCodeberg {
    owner = "natthias";
    repo = "weave";
    rev = "f8dfeabf61f23b28c3580a6f528f28c9395b0110";
    hash = "sha256-z+D+y0oUxjNHhuS0/0F8QENfHGR0j8RQjfV7UYA+4WI=";
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
