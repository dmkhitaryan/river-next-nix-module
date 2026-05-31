{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  pkg-config,
  wayland-scanner,
  wayland,
  libxkbcommon,
}:

buildGoModule(finalAttrs: {
  pname = "croffle";
  version = "unstable-2026-05-25";
  subPackages = [
    "cmd/crofflewm"
    "cmd/croffleim"
  ];

  src = fetchFromCodeberg {
    owner = "vyivel";
    repo = "croffle";
    rev = "556fe5552e0e6f920627ef4981c3c7f3da56afe3";
    hash = "sha256-a8ri5Ln+lv1ypIUr1JdJF0FKIeNkW8VM8HxROyBi2IU=";
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
