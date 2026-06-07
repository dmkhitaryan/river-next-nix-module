{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wayland-scanner,
  wayland,
  libxkbcommon,
  freetype,
  fontconfig,
}:

rustPlatform.buildRustPackage {
  pname = "canoe";
  version = "unstable-2026-06-06";

  src = fetchFromGitHub {
    owner = "roblillack";
    repo = "canoe";
    rev = "5174fd83b3650f9d038f99e675431db8edb0b95d";
    hash = "sha256-yR/iPLI/oU4xRzRiVnruKj6up+Y6Wc/r4hE75UhYmXM=";
  };

  cargoHash = "sha256-NG0h/nMhGpbSkGY79yUCfR+j/0kX9+vf0Y7eeemS4HY=";

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    libxkbcommon
    freetype
    fontconfig
  ];

  meta = {
    homepage = "https://github.com/roblillack/canoe";
    description = "Stacking window manager for the River Wayland compositor";
    longDescription = ''
      Canoe is a stacking window manager for the River Wayland compositor, written in Rust.
      Among its features are server-side decorations, multihead support, and window focus following clicks.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
}
