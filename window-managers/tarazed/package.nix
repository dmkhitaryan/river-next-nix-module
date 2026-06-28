{
  stdenv,
  fetchFromGitLab,
  wayland,
  pkg-config,
  wayland-scanner,
  wayland-protocols,
  libxkbcommon,
  gnumake,
  libbsd,
  libscfg,
  libevdev,
  pixman,
  libffi,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tarazed";
  version = "unstable-2026-06-23";

  src = fetchFromGitLab {
    domain = "gitlab.gwdg.de";
    owner = "leonhenrik.plickat";
    repo = "tarazed";
    rev = "ab7b55d5c88159b6c5e888bc52bfb785a0f1ef70";
    hash = "sha256-MMWl1V2LWNeOGhlQ6Lq4ETtb3RT9IPqL3SKATYmGMms=";
  };

  nativeBuildInputs = [
    wayland-scanner
    pkg-config
    gnumake
  ];
  buildInputs = [
    wayland
    libbsd
    libscfg
    libevdev
    pixman
    libxkbcommon
    wayland-protocols
    libffi
  ];

  installPhase = ''
    install -Dm755 tarazed $out/bin/tarazed
  '';

  meta = {
    homepage = "https://gitlab.gwdg.de/leonhenrik.plickat/tarazed";
    description = "UNIX/NeXT UI-inspired window manager for the river Wayland server";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
