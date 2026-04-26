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
  version = "unstable-2026-04-27";

  src = fetchFromCodeberg {
    owner = "sunn4room";
    repo = "bridge";
    rev = "47253fc319257db15a07574c92be898416a32a82";
    hash = "sha256-AhZBCjc+Ewa2egzX9YToS5LJR0xvXJ5Zt2vdil4c+LM=";
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
