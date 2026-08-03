{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wayland,
  wayland-scanner,
  libxkbcommon,
  gnumake,
  bindings ? null,
  layout ? null,
  configFile ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jrwm";
  version = "unstable-2026-08-01";

  src = fetchFromGitHub {
    owner = "jpco";
    repo = "jrwm";
    rev = "6a923903c94d1e976d9a8940e605a056365344c8";
    hash = "sha256-0RDndzWQI8eRscX2RvQFrwTJcWd+QwV9h3QWeIjbVsQ=";
  };

  nativeBuildInputs = [
    pkg-config
    gnumake
    wayland-scanner
  ];

  buildInputs = [
    wayland
    libxkbcommon
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'PREFIX	= /usr/local' "PREFIX	= $out" \
      --replace-fail 'MANDIR	= $(PREFIX)/man' 'MANDIR	= $(PREFIX)/share/man'
  '' + lib.optionalString (bindings != null) ''
      cp ${bindings} bindings.c
  '' + lib.optionalString (layout != null) ''
      cp ${layout} layout.c
  '' + lib.optionalString (configFile != null) ''
      cp ${configFile} jrwm.c
  '';

  meta = {
    homepage = "https://github.com/jpco/jrwm";
    description = "Simple dynamic tiling window manager that's easy to build, read, and modify.";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
