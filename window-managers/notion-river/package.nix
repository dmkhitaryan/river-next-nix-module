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
  version = "unstable-2026-07-21";

  src = fetchFromGitHub {
    owner = "Marenz";
    repo = "notion-river";
    rev = "9d12348e4c870f5db8328510bfeb3fe890c47b67";
    hash = "sha256-HgXz/vtHsuf+L27SwfTp+AO61lomTB/BxOwCn3nFhK0=";
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
