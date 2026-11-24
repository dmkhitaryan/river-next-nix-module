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
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "notion-river";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "Marenz";
    repo = "notion-river";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8tr6Zkh3Z3z8elTo7A5PoGhTIazFWFrilshJGSB5kBk=";
  };

  cargoHash = "sha256-+kg03vS1eITDhcBv4tHeL2y+eyU3TNYK4fctL9kx9/s=";

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
