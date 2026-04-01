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
rustPlatform.buildRustPackage( finalAttrs: {
  pname = "orilla";
  version = "orilla-run-v0.1.0";

  src = fetchFromSourcehut {
    owner = "~hokiegeek";
    repo = "orilla";
    tag = finalAttrs.version;
    hash = "sha256-fQPBTqboSbGtB6EoH0NU1tI1nL5Y7r64xztBJvUmJQw=";
  };

  cargoHash = "sha256-dgQWQF73AWJmt6J7wroOxTUq8liwPcDCH8iaLN/7Oms=";
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
})
