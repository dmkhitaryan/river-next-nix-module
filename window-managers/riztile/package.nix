{
  lib,
  stdenv,
  fetchFromCodeberg,
  zig_0_17,
  libxkbcommon,
  wayland,
  wayland-protocols,
  callPackage,
  pkg-config,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "riztile";
  version = "unstable-2026-10-10";

  src = fetchFromCodeberg {
    owner = "abhinaya-aryal";
    repo = "riztile";
    rev = "ab90f7ab2f015a7a682258394c290577ec838dad";
    hash = "sha256-e2Iqx5j1XwoOWiHGIlcoPTnB26T8GdS+gpSHg5rMkcw=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig_0_17
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
