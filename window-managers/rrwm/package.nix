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
  version = "unstable-2026-10-03";

  src = fetchFromGitHub {
    owner = "cap153";
    repo = "rrwm";
    rev = "fbe4b8d3650da39622e9904ba8b865dd8c6051d9";
    hash = "sha256-120akUQRzx1RrV9fZTdSUwUBeMAJFQ+4ndFxRVix/II=";
  };

  cargoHash = "sha256-Iu4dzo9i9kPkEQ/z9NOiCT2VOescb58hQ6NAAd7TlyI=";

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    libxkbcommon
  ]
  ++ lib.optional withWev wev
  ++ lib.optional withWlrRandr wlr-randr;

  postInstall = ''
    install -Dm755 $src/example/waybar_example_config.jsonc $out/example
    install -Dm755 $src/example/rrwm.desktop $out/local/share/wayland-sessions
    install -Dm755 ${exampleConfig} $out/example
  '';

  meta = {
    homepage = "https://github.com/cap153/rrwm";
    description = "Tiling window manager with a cosmic/bspwm layout";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
}
