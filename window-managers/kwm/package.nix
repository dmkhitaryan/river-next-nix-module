{
  lib,
  stdenv,
  fetchFromGitHub,
  customConfigPath ? null,
  withBar ? true,
  withSolidBackground ? false,
  zig,
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
  version = "unstable-2026-08-10";

  src = fetchFromGitHub {
    owner = "kewuaa";
    repo = "kwm";
    rev = "adb10add394ada9d21b46e146acb4e4d4d016c28";
    hash = "sha256-aSnprpvbUSjOgQXvGWM46+f2prPujEqKgmkd9YfuJ0M=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig
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
  ++ [
    "-Doptimize=ReleaseSafe"
    "-Dkwim=false"
  ]
  ++ lib.optional (customConfigPath != null) "-Dconfig=${customConfigPath}"
  ++ lib.optional withBar "-Dbar"
  ++ lib.optional withSolidBackground "-Dbackground";

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
