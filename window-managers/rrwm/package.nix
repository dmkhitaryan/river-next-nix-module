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
  version = "unstable-2026-04-02";

  src = fetchFromGitHub {
    owner = "cap153";
    repo = "rrwm";
    rev = "22c65be4b1c48d0b3d9e56c86ff5526ffdcdb20a";
    hash = "sha256-bayl5G4fvWPJ8HWTSwS766GWbf2GhQkj6YZeT1HWic4=";
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
