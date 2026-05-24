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
  version = "unstable-2026-05-21";
  subPackages = [
    "cmd/crofflewm"
    "cmd/croffleim"
  ];

  src = fetchFromCodeberg {
    owner = "vyivel";
    repo = "croffle";
    rev = "225cb8567c87a758efeaa8cd6c3bb1f32a7455bc";
    hash = "sha256-/w7QgYLHOE+8kpRa6gJiYMj7mcG87ykMJK/weXWo2kc=";
  };

  vendorHash = "sha256-Cmg4duoGUa+YpOPNAcqFUgV25E6IqINq18jbA8zRRNQ=";

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
