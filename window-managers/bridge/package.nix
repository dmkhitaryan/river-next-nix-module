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
  pname = "beansprout";
  version = "3.2.0";

  src = fetchFromCodeberg {
    owner = "sunn4room";
    repo = "bridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nvH9xp8E8ccHE11F2ip+Vs0PHw6T5zRErv5jqVoOmqs=";
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
