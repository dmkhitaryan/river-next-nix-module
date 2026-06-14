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
  version = "unstable-2026-06-10";

  src = fetchFromGitHub {
    owner = "roblillack";
    repo = "canoe";
    rev = "7f6b1bae4a41c98ad0bf890261f34ba1c257e037";
    hash = "sha256-oAptabkO0gBZQZocKLP/BGzHt6GGRwkFtt3/rhGraiU=";
  };

  cargoHash = "sha256-qMzqyZ6dSyIYhsXBjvtSiX4pptKP+6G3fze8NSPeza4=";

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
