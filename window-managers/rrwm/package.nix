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
  version = "unstable-2026-10-07";

  src = fetchFromGitHub {
    owner = "cap153";
    repo = "rrwm";
    rev = "ac614e17f67fe578e5821cc3bc8f22ff228a4309";
    hash = "sha256-vwR9HWmMWC/AqTqffr7ZMsfZ4cUL3BwQL9XSPX49wWI=";
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
