{
  lib,
  stdenv,
  fetchFromCodeberg,
  wayland,
  guile-cairo,
  guile,
  pango,
  pkg-config,
  wayland-scanner,
  gnumake,
  wayland-protocols,
  libxkbcommon,
  librsvg,
  makeWrapper,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gliver";
  version = "unstable-2026-11-09";

  src = fetchFromCodeberg {
    owner = "ebeem";
    repo = "gliver";
    rev = "5590beedc5b21ea602403cd760e08a1c5dffbe8e";
    hash = "sha256-EWKuHPwzC0nJCxAEuafVviTF4R2YxxsVlIKUMB7drqk=";
  };

  nativeBuildInputs = [
    wayland-scanner
    pkg-config
    gnumake
    makeWrapper
  ];

  buildInputs = [
    wayland
    guile
    guile-cairo
    pango
    librsvg
    wayland-protocols
    libxkbcommon
  ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  makeFlags = [
    "PREFIX=$(out)"
  ];

  postInstall = ''
    wrapProgram "$out/bin/gliver" \
      --prefix GUILE_LOAD_PATH : "$out/share/guile/site/3.0:${guile-cairo}/share/guile/site" \
      --prefix GUILE_EXTENSIONS_PATH : "${guile-cairo}/lib"
  '';

  meta = {
    homepage = "https://codeberg.org/ebeem/gliver";
    description = "Guile scheme wayland window manager based on river and inspired by emacs and stumpwm";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
