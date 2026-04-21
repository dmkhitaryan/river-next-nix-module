{
  lib,
  stdenv,
  fetchFromCodeberg,
  zig_0_15,
  libxkbcommon,
  wayland,
  wayland-protocols,
  callPackage,
  pkg-config,
  wayland-scanner,
  bison,
  pixman,
  fcft,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bridge";
  version = "unstable-2026-04-20";

  src = fetchFromCodeberg {
    owner = "sunn4room";
    repo = "bridge";
    rev = "62150b0b5c9e9a394581752666f07a4a1a334f52";
    hash = "sha256-DfRkt93McX+pjryOfxptTcV82FMf1N4BKntoEgwe5rQ=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig_0_15
    wayland-scanner
    wayland-protocols
    pkg-config
    bison
  ];
  buildInputs = [
    libxkbcommon
    wayland
    pixman
    fcft
  ];

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ]
  ++ [ "-Doptimize=ReleaseSafe" ];

  meta = {
    homepage = "https://github.com/sunn4room/bridge";
    description = "Horizontal-tiling window manager based on river wayland compositor";
    longDescription = ''
      Bridge is a horizontal-tiling window manager based on river wayland compositor.
      Under a bridge, there are bridge openings of different sizes arranged horizontally.
      This window manager also has windows of different widths tiled horizontally.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
