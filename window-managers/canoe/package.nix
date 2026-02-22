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
  version = "unstable-2026-02-11";

  src = fetchFromGitHub {
    owner = "roblillack";
    repo = "canoe";
    rev = "7791c580c91ef97c3fde3f3ac24c778653b7c05f";
    hash = "sha256-WFgFfElhEH2wfcQZr8sx/1zjRT/wMriQ/HA6PTyM7hw=";
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
}
