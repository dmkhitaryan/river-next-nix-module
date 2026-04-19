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
}:
let
  river-next = callPackage ../../river-next.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "anvl";
  version = "unstable-2026-04-20";

  src = fetchFromCodeberg {
    owner = "auoggi";
    repo = "anvl";
    rev = "8eab9e7a6a4c0258887f1ffd5ab421582819d7d0";
    hash = "sha256-k9+KBsKm3AgBYCLBf600WWB9ot+LZIdk/grYpjvhOa8=";
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
  ];

  preBuild = ''
    mkdir -p .build
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 .build/anvl $out/bin/anvl
    runHook postInstall
  '';

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'fd -e xml . protocol' 'fd -e xml . ${river-next}/share/river-protocols/stable' \
      --replace-fail 'protocol/%.xml' '${river-next}/share/river-protocols/stable/%.xml'
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
