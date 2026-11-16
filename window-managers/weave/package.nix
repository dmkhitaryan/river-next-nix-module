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
  version = "unstable-2026-11-15";

  src = fetchFromCodeberg {
    owner = "natthias";
    repo = "weave";
    rev = "0d7ac71e31628e5b09f7a10b32a38890842d67e2";
    hash = "sha256-FCqK4p/C4LpbcFQ9yQS6U5EMTZGWvvfzUVtG1DrKLzA=";
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
    find src -name '*.hh' -exec sed -i '1i#include <cstdint>' {} +

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
