{
  lib,
  stdenv,
  fetchFromGitHub,
  withBar ? true,
  withCustomConfig ? false,
  scdoc,
  zig_0_15,
  libxkbcommon,
  wayland,
  wayland-protocols,
  callPackage,
  pkg-config,
  wayland-scanner,
  pixman,
  fcft,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kwm";
  version = "unstable-2026-05-04";

  src = fetchFromGitHub {
    owner = "kewuaa";
    repo = "kwm";
    rev = "db4c53d50488df3f190dabef78e7c82d4b9e0432";
    hash = "sha256-gpVBhdfYTVeUBi+tZBWdejCxD/dOEWGwmYtBxXOKVVk=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig_0_15
    wayland-scanner
    pkg-config
  ];
  buildInputs = [
    wayland
    wayland-protocols
    pixman
    fcft
    libxkbcommon
  ];

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ]
  ++ [ "-Doptimize=ReleaseSafe" ]
  ++ lib.optional withBar "-Dbar"
  ++ lib.optional withCustomConfig "-Dconfig";

  meta = {
    homepage = "https://github.com/kewuaa/kwm";
    description = "Window manager based on River Wayland compositor";
    longDescription = ''
      kwm is a window manager based on river >= 0.4.x (with river-window-management-v1 protocol), written in Zig.
      kwm supports multiple layouts (tile, grid, scroller to list a few), per-mode keybindings, hot reload, and more.
    '';
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
