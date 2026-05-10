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
  version = "unstable-2026-05-10";
  subPackages = [
    "cmd/crofflewm"
    "cmd/croffleim"
  ];

  src = fetchFromCodeberg {
    owner = "vyivel";
    repo = "croffle";
    rev = "d597b473a7e38b2f9b959d03d90b3d1feb56ccae";
    hash = "sha256-a28Gk2/rbufPRrXX4P0RO3WxLaN/HPEVH9tdlR8f0Ac=";
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
