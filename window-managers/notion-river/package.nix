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
  version = "unstable-2026-08-05";

  src = fetchFromGitHub {
    owner = "Marenz";
    repo = "notion-river";
    rev = "e79dea34c3f32987c42e338db6a5c341bce0af23";
    hash = "sha256-nJTxbUbzuQn9+SukHYDtsOKWt98k5hDr+T/ZMgPgH+E=";
  };

  cargoHash = "sha256-DDZfkqfiiYYad2rB1wvcJdL1Pbvfe8fTJXpfv+lCGKw=";

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
