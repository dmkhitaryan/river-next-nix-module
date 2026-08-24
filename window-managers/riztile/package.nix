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
  version = "unstable-2026-08-24";

  src = fetchFromCodeberg {
    owner = "abhinaya-aryal";
    repo = "riztile";
    rev = "b2217242fd3daae6bf99dba00e373ee4d0eb6fb4";
    hash = "sha256-CEucmMkfjczDxVBVAwCHyEcFwbpuipasgSK41k/Wt1c=";
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
