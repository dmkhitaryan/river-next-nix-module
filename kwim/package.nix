{
  lib,
  stdenv,
  fetchFromGitHub,
  customConfigPath ? null,
  customKwmConfigPath ? null,
  withBashCompletion ? true,
  withZshCompletion ? true,
  zig,
  libxkbcommon,
  wayland,
  wayland-protocols,
  callPackage,
  pkg-config,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kwim";
  version = "unstable-2026-05-22";

  src = fetchFromGitHub {
    owner = "kewuaa";
    repo = "kwim";
    rev = "7603ba91e2e6bf9d6ad98a346d5cb5effabc6fb5";
    hash = "sha256-fRoMXuDORckJQCoUKbt5PxPFs48JED6PGYjBuJcrfbo=";
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
    libxkbcommon
  ];

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ]
  ++ [ "-Doptimize=ReleaseSafe" ]
  ++ lib.optional (customConfigPath != null) "-Dconfig=${customConfigPath}"
  ++ lib.optional (customKwmConfigPath != null) "-Dkwm-config=${customKwmConfigPath}"
  ++ lib.optional withBashCompletion "-Dbash-completion"
  ++ lib.optional withZshCompletion "-Dzsh-completion";

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
