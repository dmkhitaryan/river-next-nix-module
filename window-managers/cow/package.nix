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
  version = "unstable-2026-05-16";

  src = fetchFromCodeberg {
    owner = "thomasadam";
    repo = "cow";
    rev = "22dcde6955e788673fc5dee9b755635dda4efbc4";
    hash = "sha256-l9YOgM/W/sMYDMqXl+bkHjIMZnMxJZyrAOCop6ww4uw=";
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
