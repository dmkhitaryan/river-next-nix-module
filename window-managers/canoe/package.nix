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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "roblillack";
    repo = "canoe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dbbL+u7dxQbTSkDgprrpsccSrwCp0d7MkuvH0O0t5SY=";
  };

  cargoHash = "sha256-U0cn8q2DsVuTEXstgNTt2e9Pz0BeXPE+OQG4yLcvJ38=";

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
