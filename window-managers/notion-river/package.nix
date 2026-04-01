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
rustPlatform.buildRustPackage(finalAttrs: {
  pname = "notion-river";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Marenz";
    repo = "notion-river";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZZgzPOvgyopLfzWsV4ijL22xXiTBKujnVe+obDw9jI8=";
  };

  cargoHash = "sha256-XZMAUiPHnjZuNLCpEu9c5vWtv4Zy1wGb5aKKTl+3zZU=";

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
})
