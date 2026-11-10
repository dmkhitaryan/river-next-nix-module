{
  lib,
  stdenv,
  fetchFromGitHub,
  customConfigPath ? null,
  withBar ? true,
  withSolidBackground ? false,
  zig_0_16,
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
  version = "unstable-2026-11-10";

  src = fetchFromGitHub {
    owner = "kewuaa";
    repo = "kwm";
    rev = "16979ae6e17526373d60292da83ef03c6f25f1fb";
    hash = "sha256-pfGevehlwEGJbyynfSQUML5KCKcyW2ytqiN1blYbhRM=";
  };

  deps = callPackage ./build.zig.zon.nix {};

  nativeBuildInputs = [
    zig_0_16
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

  zigBuildFlags =
    [
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
