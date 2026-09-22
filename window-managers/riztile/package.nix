{
  lib,
  stdenv,
  fetchFromCodeberg,
  zig,
  libxkbcommon,
  wayland,
  wayland-protocols,
  callPackage,
  pkg-config,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "riztile";
  version = "unstable-2026-09-20";

  src = fetchFromCodeberg {
    owner = "abhinaya-aryal";
    repo = "riztile";
    rev = "547a9eb247846220034a649eb50c73fcf04442c9";
    hash = "sha256-CiTj6oy0OLCC2OpEqkXfQah5DvfUJmpiQ98I3dbYp7w=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig
    wayland-scanner
    pkg-config
  ];
  buildInputs = [
    libxkbcommon
    wayland
    wayland-protocols
  ];

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ]
  ++ [ "-Doptimize=ReleaseSafe" ];

  meta = {
    homepage = "https://codeberg.org/abhinaya-aryal/riztile";
    description = "Minimalist scrolling window manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };

})
