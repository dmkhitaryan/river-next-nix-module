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
  version = "unstable-2026-05-27";

  src = fetchFromGitHub {
    owner = "Marenz";
    repo = "notion-river";
    rev = "6ae05c86a19f462258352899f72923480aaf57bb";
    hash = "sha256-4xqT+r+hO0GPykusvoYJLjps3vcRnd+MeZVRh9c/6Ow=";
  };

  cargoHash = "sha256-ZeWM6j58Gd8YV4lIgD//W3F1qc8/dlz2ss+/Sjam1Hk=";

  checkFlags = [
    "--skip=focus::tests::wm_integration::test_wm_focus_follows_pointer_to_empty_frame"
  ];

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
