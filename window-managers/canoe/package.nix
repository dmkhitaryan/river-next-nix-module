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

rustPlatform.buildRustPackage(finalAttrs: {
  pname = "canoe";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "roblillack";
    repo = "canoe";
    tag = "v${finalAttrs.version}";
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
})
