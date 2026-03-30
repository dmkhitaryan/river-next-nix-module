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
  version = "unstable-2026-03-30";

  src = fetchFromCodeberg {
    owner = "g4b";
    repo = "mousetrap";
    rev = "b798297f2d40dad50f76707e0e18d1f3d36e5b95";
    hash = "sha256-HsPWsOY3BnYc4BVKzpGtZinzvJj37PfFiMoLd6qem3c=";
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
