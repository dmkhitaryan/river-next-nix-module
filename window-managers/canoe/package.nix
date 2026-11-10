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
  version = "unstable-2026-11-07";

  src = fetchFromGitHub {
    owner = "roblillack";
    repo = "canoe";
    rev = "044f2a2fbec1f93e2fde394616370eb96125bd29";
    hash = "sha256-PCGEswByqdIoAR5jidhCqixcSoDqvp86/oB5+Pw2wSA=";
  };

  cargoHash = "sha256-2J+s4lgXQQuD594Yuf+DU5fjkb8z5CecPt03R6UC7WI=";

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
