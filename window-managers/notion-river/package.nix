{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wayland-scanner,
  wayland,
  libxkbcommon,
  cairo,
  pango,
}:
rustPlatform.buildRustPackage {
  pname = "notion-river";
  version = "unstable-2026-04-06";

  src = fetchFromGitHub {
    owner = "Marenz";
    repo = "notion-river";
    rev = "1a913958783b6b27f49696c6141c0d1ac4782062";
    hash = "sha256-IEja8aX1p6NbRUKHwhPWn85vGQE+lnxqm7Wao9G5E8c=";
  };

  cargoHash = "sha256-ZeWM6j58Gd8YV4lIgD//W3F1qc8/dlz2ss+/Sjam1Hk=";

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    libxkbcommon
    cairo
    pango
  ];

  postInstall = ''
    cp -r $src/config-examples/ $out
  '';

  meta = {
    homepage = "https://github.com/Marenz/notion-river";
    description = "Notion/Ion3-style static tiling window manager for the River Wayland compositor";
    longDescription = ''
      notion-river is a static tiling window manager for the River Wayland compositor. Inspired by Notionwm (previously Ion3).
      As a result, unlike other tiling window managers, notion-river uses persistent frames. User has to explicitly split/unsplit layout.
      Additionally supporting floating mode, has waybar integration, and more.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
}
