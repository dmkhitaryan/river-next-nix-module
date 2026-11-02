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
  libxml2,
  withCowdiag ? true,
  withCowappmenu ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cow";
  version = "unstable-2026-11-02";

  src = fetchFromCodeberg {
    owner = "cow-wm";
    repo = "cow";
    rev = "c33c03f65f8bdaa566ba268df6d7605b78f3ca89";
    hash = "sha256-X6WuR0PgjehRMS+2r/fAt9xcrW3mCUvxXqjNveLwsBw=";
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
  ++ lib.optional withCowdiag ncurses
  ++ lib.optional withCowappmenu libxml2;

  env.NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  postInstall = ''
    install -Dm755 $src/config/cow/cow.conf $out/examples/cow.conf
  '';

  mesonFlags = [
    "-Dcowdiag=${if withCowdiag then "enabled" else "disabled"}"
    "-Dcow_appmenu=${if withCowappmenu then "enabled" else "disabled"}"
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
