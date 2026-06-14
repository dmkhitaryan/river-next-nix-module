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
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "roblillack";
    repo = "canoe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oHaoeLQhj0L+1URXIrgfuFkAScXVVWqDiGdxq14zUqI=";
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
})
