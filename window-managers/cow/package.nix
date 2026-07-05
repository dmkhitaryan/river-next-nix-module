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
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cow";
  version = "unstable-2026-07-04";

  src = fetchFromCodeberg {
    owner = "thomasadam";
    repo = "cow";
    rev = "fcb46581ad2ae4b62a9a04e0609b8374ad2f4903";
    hash = "sha256-Cm9am0ZshXSP963afqFsPZ//avYwrQvMCMeKgXAcYZs=";
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
