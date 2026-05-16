{
  lib,
  rustPlatform,
  fetchFromSourcehut,
  pkg-config,
  wayland-scanner,
  wayland,
  libxkbcommon,
  wayland-protocols,
}:

let
  defaultConfig = ./default.toml;
in
rustPlatform.buildRustPackage {
  pname = "orilla";
  version = "unstable-2026-03-08";

  src = fetchFromSourcehut {
    owner = "~hokiegeek";
    repo = "orilla";
    rev = "bd77afb99a192c10211385df4555e68e786094fb";
    hash = "sha256-FwLKvIB4VXRhD0/1HpEdGwMp/EfGqTC2AfVs354uD3c=";
  };

  cargoHash = "sha256-fTKgRSDtV+5Dn4QAfBYsUbdaNj5GsVAwnYVwpw7VJms=";
  patches = [ ./xdg-config-path.patch ];

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    libxkbcommon
    wayland-protocols
  ];

  postInstall = ''
    install -Dm755 ${defaultConfig} $out/example/default.toml
  '';

  meta = {
    homepage = "https://git.sr.ht/~hokiegeek/orilla";
    description = "Rust-based window manager for the Wayland compositor, river";
    longDescription = ''
      orilla is a Rust-based window manager for the river Wayland compositor.
      Inspired by XMonad, it exists for a simple reason: layout is ergonomics. How your tools are arranged affects how well you can use them.
      (too much) more: https://man.sr.ht/~hokiegeek/orilla/#philosophy
    '';
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };

}
