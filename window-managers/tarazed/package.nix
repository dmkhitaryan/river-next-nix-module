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
  version = "unstable-2026-05-17";

  src = fetchFromGitLab {
    domain = "gitlab.gwdg.de";
    owner = "leonhenrik.plickat";
    repo = "tarazed";
    rev = "0dc46fc2745952aae8c13bf7838c09d34b3c6c1b";
    hash = "sha256-7R0z3Y80xWqIyWJHl6Fd0D682tZmOwMs0Fopl4/h7y4=";
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
