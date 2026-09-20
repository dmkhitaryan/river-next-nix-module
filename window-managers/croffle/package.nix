{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  pkg-config,
  wayland-scanner,
  wayland,
  libxkbcommon,
}:

buildGoModule (finalAttrs: {
  pname = "croffle";
  version = "unstable-2026-07-26";
  subPackages = [
    "cmd/crofflewm"
    "cmd/croffleim"
  ];

  src = fetchFromCodeberg {
    owner = "vyivel";
    repo = "croffle";
    rev = "6aafda16763160217711cb0f6a29dda053e80bd2";
    hash = "sha256-jgAlbsl56DKqx79FvLU7824HaEcwP9f5dWA/X4stYs8=";
  };

  vendorHash = "sha256-htk26isEZX3Lh+k+a1nrAZAxq83wjgccebVWgyQTu7w=";

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    libxkbcommon
  ];

  meta = {
    homepage = "https://github.com/vyivel/croffle";
    description = "Static tiling window manager for the River Wayland compositor";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
