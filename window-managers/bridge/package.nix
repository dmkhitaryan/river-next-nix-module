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
  version = "unstable-2026-04-12";

  src = fetchFromCodeberg {
    owner = "sunn4room";
    repo = "bridge";
    rev = "94b9a36c78e0f74eb24986548bb58a04acc76660";
    hash = "sha256-vsmhAygD/rYcKfs+2Xvv7yEfv1+CKzHap+3DlfX+iFE=";
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
