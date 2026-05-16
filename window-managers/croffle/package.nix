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
  version = "unstable-2026-05-16";
  subPackages = [
    "cmd/crofflewm"
    "cmd/croffleim"
  ];

  src = fetchFromCodeberg {
    owner = "vyivel";
    repo = "croffle";
    rev = "e357764c6182824ae54d2c7a408cf738b05a3956";
    hash = "sha256-HB1scsdEC51BfOEhGO/pIxVZGdz/bTOoRLC0JAWUSko=";
  };

  vendorHash = "sha256-JRRQjzXvYlDENL6sdyWVMqIAuhoGse1F4Kj/fELtsjQ=";

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
