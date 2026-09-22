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
  version = "unstable-2026-09-19";

  src = fetchFromCodeberg {
    owner = "auoggi";
    repo = "anvl";
    rev = "ab991f87a80469b0454d645f8299587f27d81207";
    hash = "sha256-DtdH7meixHjeGhgowscc8UmL+t6cgtnFVyg3oK14dqE=";
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
