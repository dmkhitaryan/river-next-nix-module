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
  version = "unstable-2026-10-18";

  src = fetchFromCodeberg {
    owner = "Sivecano";
    repo = "channel";
    rev = "38ba686d68ac678cc5b6b719f63bd85e7420fe69";
    hash = "sha256-h6kN1eZT0BI+YsG1IE7tZQfGWmLWPwAX1ZrKTYpQXL4=";
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
