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
  version = "unstable-2026-05-21";

  src = fetchFromGitHub {
    owner = "roblillack";
    repo = "canoe";
    rev = "2a953b11f548fd541af9b4ba86baa48d87282eb1";
    hash = "sha256-jhRFoM82eHoQMaUQthYDCe94Sw7OT/V6Dv4pmATU7aw=";
  };

  cargoHash = "sha256-jPDCRkarzdEfi725eEnnZZwvTXREb1WsKu0FWMvjMPY=";

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
