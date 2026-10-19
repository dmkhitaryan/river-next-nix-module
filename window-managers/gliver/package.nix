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
  version = "unstable-2026-10-19";

  src = fetchFromCodeberg {
    owner = "ebeem";
    repo = "gliver";
    rev = "1da4a5a19908f34d2c25e1445cf955fb71df4ade";
    hash = "sha256-J9HgvSC5HWxPA9VcTG93mMgiJkiQ8qoCO04UFk3rdmo=";
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
