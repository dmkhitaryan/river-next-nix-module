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
  version = "unstable-2026-06-13";

  src = fetchFromGitHub {
    owner = "jpco";
    repo = "jrwm";
    rev = "119dfc80fa0e2fc9caaf2626be09ed68c890a650";
    hash = "sha256-/fsykASlLC3U3I0B0BS46dtkJPuzzjIm0rZRXL5t5BY=";
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
      --replace-fail 'INSTALL	= /usr/bin/install -c -s' 'INSTALL	= install -c -s' \
      --replace-fail 'MKDIR_P	= /usr/bin/mkdir -p' 'MKDIR_P	= mkdir -p' \
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
