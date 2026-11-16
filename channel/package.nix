{
  lib,
  stdenv,
  fetchFromCodeberg,
  zig_0_17,
  wayland-scanner,
  wayland,
  wayland-protocols,
  pkg-config,
  libxkbcommon,
  callPackage,
}:
let
  river-next = callPackage ../river-next.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "channel";
  version = "unstable-2026-11-12";

  src = fetchFromCodeberg {
    owner = "Sivecano";
    repo = "channel";
    rev = "2789cfdbd8971cc619241cd7b96ef867a0446bc1";
    hash = "sha256-n8BUNr78lnAYjeFgihhtdgGAYoDzp+FvjQwIdbIAWJo=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig_0_17
    wayland-scanner
    pkg-config
    river-next
  ];
  buildInputs = [
    wayland
    wayland-protocols
    libxkbcommon
  ];

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ]
  ++ [ "-Doptimize=ReleaseSafe" ];

  meta = with lib; {
    description = "Input configuration daemon for River";
    homepage = "https://codeberg.org/Sivecano/channel";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
})
