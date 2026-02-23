{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wayland-scanner,
  wayland,
  libxkbcommon,
  withWev ? false,
  withWlrRandr ? false,
  wev,
  wlr-randr,
}:
let
  exampleConfig = ./rrwm.toml;
in
rustPlatform.buildRustPackage {
  pname = "rrwm";
  version = "unstable-2026-02-20";

  src = fetchFromGitHub {
    owner = "cap153";
    repo = "rrwm";
    rev = "6002aca72a10d1a238e64ba0626a5c1a5eee8b9d";
    hash = "sha256-Tqw1SYCwvvTt1BaxM7dDUy+Q74U8BjkigZsB68COYdo=";
  };

  cargoHash = "sha256-8OiF34Aa/jH82MAcQ5HnIW+4Bi9wLK904kfJvdHVrEc=";

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    libxkbcommon
  ] ++ lib.optional withWev wev
    ++ lib.optional withWlrRandr wlr-randr;

  postInstall = ''
    install -Dm755 $src/example/waybar_example_config.jsonc $out/example
    install -Dm755 $src/example/rrwm.desktop $out/local/share/wayland-sessions
    install -Dm755 ${exampleConfig} $out/example
  '';
}
