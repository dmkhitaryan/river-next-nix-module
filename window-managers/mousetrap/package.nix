{
  lib,
  stdenv,
  fetchFromCodeberg,
  wayland,
  cairo,
  pango,
  tomlplusplus,
  pkg-config,
  wayland-scanner,
  meson,
  git,
  libxkbcommon,
  cmake,
  wayland-protocols,
  ninja,
  spdlog,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mousetrap";
  version = "unstable-2026-06-05";

  src = fetchFromCodeberg {
    owner = "g4b";
    repo = "mousetrap";
    rev = "02fe85d46abcae21ddf601b0374264bbd785a574";
    hash = "sha256-rudg1GzGURirRHX13gJAEJUpIKq2NhtIozh3eBKEOuI=";
  };

  nativeBuildInputs = [
    wayland-scanner
    meson
    git
    pkg-config
    cmake
    ninja
  ];
  buildInputs = [
    wayland
    cairo
    pango
    spdlog
    tomlplusplus
    libxkbcommon
    wayland-protocols
  ];

  postInstall = ''
    install -Dm755 $src/config.toml $out/examples/config.toml
  '';

  meta = {
    homepage = "https://codeberg.org/g4b/mousetrap";
    description = "Ratpoison/stumpwm-like window manager for river >= 0.4";
    longDescription = ''
      Mousetrap is a minimal window manager intended to replicate stumpwm/ratpoison behavior:
      - Fullscreen only windows.
      - Configurable keybindings with support for prefixes.
      - No window decorations.
      - Minimally themeable UI.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
