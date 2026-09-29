{
  lib,
  stdenv,
  fetchFromCodeberg,
  wayland,
  cairo,
  pango,
  pkg-config,
  wayland-scanner,
  meson,
  cmake,
  wayland-protocols,
  libbsd,
  libxkbcommon,
  scdoc,
  bison,
  flex,
  libevent,
  ninja,
  ncurses,
  withCowdiag ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cow";
  version = "unstable-2026-09-29";

  src = fetchFromCodeberg {
    owner = "thomasadam";
    repo = "cow";
    rev = "3fd3973e4219485cac9185a3ce72896ccdd3ccb6";
    hash = "sha256-2XRSjZ2UWXcl3HsjEZU4t8XUmX+8FX/5VP9uozo9r1g=";
  };

  nativeBuildInputs = [
    wayland-scanner
    meson
    pkg-config
    cmake
    bison
    flex
    ninja
  ];

  buildInputs = [
    wayland
    cairo
    pango
    libbsd
    wayland-protocols
    libxkbcommon
    scdoc
    libevent
  ]
  ++ lib.optional withCowdiag ncurses;

  env.NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  postInstall = ''
    install -Dm755 $src/config/cow/cow.conf $out/examples/cow.conf
  '';

  mesonFlags = [
    "-Dcowdiag=${if withCowdiag then "enabled" else "disabled"}"
  ];

  meta = {
    homepage = "Compositor on Wayland - cow aims to behave like fvwm and mwm from X11";
    description = "Ratpoison/stumpwm-like window manager for river >= 0.4";
    longDescription = ''
      CoW is a window manager, similar in look and feel to fvwm/mwm.
      It uses dedicated commands that can be used both as a configuration file, and via IPC.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
