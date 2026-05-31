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
  ninja,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cow";
  version = "unstable-2026-05-30";

  src = fetchFromCodeberg {
    owner = "thomasadam";
    repo = "cow";
    rev = "d957099dd16886195f2342622fe677856c80f9c6";
    hash = "sha256-QYpHSPyNfwyMQP/bgjHyuEl01eczJITUIYKMQZ4fph8=";
  };

  nativeBuildInputs = [
    wayland-scanner
    meson
    pkg-config
    cmake
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
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  postInstall = ''
    install -Dm755 $src/config/cow/cow.conf $out/examples/cow.conf
  '';

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
