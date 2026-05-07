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
  version = "unstable-2026-05-07";
  subPackages = [
    "cmd/crofflewm"
    "cmd/croffleim"
  ];

  src = fetchFromCodeberg {
    owner = "vyivel";
    repo = "croffle";
    rev = "e7be3942695f243a2d90288d8afcd939db61a01f";
    hash = "sha256-UHMet+fPhxZraKbyFaap0OYrJr9/swuZ+AsTXrkfVS8=";
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
