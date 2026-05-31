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
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tarazed";
  version = "unstable-2026-05-30";

  src = fetchFromGitLab {
    domain = "gitlab.gwdg.de";
    owner = "leonhenrik.plickat";
    repo = "tarazed";
    rev = "27ad369e38e20ab8ede2552ef757b4018bcb48a4";
    hash = "sha256-+LPMF7Ov2JeQUJhMarNbMT1s12kzBB/1uKJB3ShoExA=";
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
