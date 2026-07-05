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
  version = "unstable-2026-06-30";

  src = fetchFromGitLab {
    domain = "gitlab.gwdg.de";
    owner = "leonhenrik.plickat";
    repo = "tarazed";
    rev = "d093af64c2d07006e8311c18e56503f02c9e121e";
    hash = "sha256-R0uGQaN6TU6Er31roB0zP3xXZHYDQY9hz5PzFjttBms=";
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
