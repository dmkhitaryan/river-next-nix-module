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
  version = "unstable-2026-10-14";

  src = fetchFromGitLab {
    domain = "gitlab.gwdg.de";
    owner = "leonhenrik.plickat";
    repo = "tarazed";
    rev = "df3c370982fa30de1b39689bcb5f80eab5e4df5d";
    hash = "sha256-R2rM85dSjLWrCbbKdryiiP9PA39n97HfKooZCd7cZts=";
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
