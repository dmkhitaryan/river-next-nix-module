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
  version = "unstable-2026-11-05";
  subPackages = [
    "cmd/crofflewm"
    "cmd/croffleim"
  ];

  src = fetchFromCodeberg {
    owner = "vyivel";
    repo = "croffle";
    rev = "f0347874668f383fc2db36ca5cd2ec5e26bc398d";
    hash = "sha256-/wbpWp1OySU8dWIHg1hqyM4DcVdj3NXHY6BD+duO82U=";
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
