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
  version = "unstable-2026-09-10";

  src = fetchFromCodeberg {
    owner = "auoggi";
    repo = "anvl";
    rev = "eb6ca87c00a194fc6a467b3c79c5d9430d322b87";
    hash = "sha256-oH8FZeeZduImLI13dzr0+t2tX/eRCfbG6DwKpD8VMa4=";
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
