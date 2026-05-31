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
  version = "unstable-2026-05-29";

  src = fetchFromGitHub {
    owner = "roblillack";
    repo = "canoe";
    rev = "396524703ae0287ab63588ff76c05a092d47ace3";
    hash = "sha256-SIBQ/sSpkVVWCxTNByR+jTmzp82ibiuIeH9wupcsp6c=";
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
}
