{
  lib,
  stdenv,
  fetchFromCodeberg,
  zig,
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
  version = "unstable-2026-06-21";

  src = fetchFromCodeberg {
    owner = "Sivecano";
    repo = "channel";
    rev = "48780de49028857133ee0ebd2f96d30a335e0764";
    hash = "sha256-Fq1vhLKPeLdyYEq+DtlPpUJsMYm9EBJsMeDeGSH2588=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig
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
