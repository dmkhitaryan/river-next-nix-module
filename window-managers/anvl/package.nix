{
  lib,
  stdenv,
  fetchFromCodeberg,
  wayland,
  pkg-config,
  wayland-scanner,
  libxkbcommon,
  gnumake,
  wayland-protocols,
  fd,
  callPackage,
  fcft,
  pixman,
}:
let
  river-next = callPackage ../../river-next.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "anvl";
  version = "unstable-2026-09-27";

  src = fetchFromCodeberg {
    owner = "auoggi";
    repo = "anvl";
    rev = "0982c88a869dc5b65c7105fb7986cdbc990a9568";
    hash = "sha256-SVyxpPaLAfLGwGdFA4KJo7RVU4C/SzkSLHniHvKQfbg=";
  };

  nativeBuildInputs = [
    river-next
    wayland-scanner
    pkg-config
    gnumake
  ];

  buildInputs = [
    wayland
    libxkbcommon
    wayland-protocols
    fd
    fcft
    pixman
  ];

  preBuild = ''
    mkdir -p .build
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 .build/anvl $out/bin/anvl
    runHook postInstall
  '';

  meta = {
    homepage = "https://codeberg.org/auoggi/anvl";
    description = "Tiling window manager inspired and influenced by dwm and tinyrwm.";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
