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
  version = "unstable-2026-11-14";

  src = fetchFromGitHub {
    owner = "kewuaa";
    repo = "kwm";
    rev = "8dafe7ec636894131521990c2effa3daa09eb205";
    hash = "sha256-3uDLdkltKwMcUG+qGpQtz1OZGln4BrYSzRXTMZVD0qk=";
  };

  deps = callPackage ./build.zig.zon.nix {};

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
