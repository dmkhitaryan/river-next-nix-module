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
  version = "unstable-2026-11-08";

  src = fetchFromCodeberg {
    owner = "auoggi";
    repo = "anvl";
    rev = "05e467cf339d1c372ff4c9ab41f0d5a87272b90e";
    hash = "sha256-djmuY76gg14PtcyujB88AKbLjmUOSzHyuY9oB5AZX8I=";
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
