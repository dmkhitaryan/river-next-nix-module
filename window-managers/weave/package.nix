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
  version = "unstable-2026-11-22";

  src = fetchFromCodeberg {
    owner = "natthias";
    repo = "weave";
    rev = "6b0fad0c76b4f35f06268b5604dd49237f475075";
    hash = "sha256-pVjJabjRb+63BFR92lqarBs+/Ephen6EJEe4WJC/6Oo=";
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
    sed -i '1i#include <array>' src/weave/Output.hh
    sed -i '1i#include <limits>' src/weave/Output.hh
    sed -i '1i#include <optional>' src/weave/WindowRule.hh
    sed -i '1i#include <utility>' src/weave/WindowRule.hh
    sed -i '1i#include <optional>' src/weave/Window.hh
    sed -i '1i#include <optional>' src/common/include/util.hh
      
    substituteInPlace src/weave/Weave.hh \
      --replace-fail \
      'static const varlink_handler varlink_handler;' \
      'static const struct varlink_handler varlink_handler;'
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
