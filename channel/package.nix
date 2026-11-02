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
  version = "unstable-2026-10-28";

  src = fetchFromCodeberg {
    owner = "Sivecano";
    repo = "channel";
    rev = "803382a9972b39942abe1fb527448f4e05dce6f8";
    hash = "sha256-7okWgYaxybijX9/Ll0JGF12B8YiuQaUT8jNdUTa7tXM=";
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
