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
  version = "unstable-2026-09-27";

  src = fetchFromCodeberg {
    owner = "abhinaya-aryal";
    repo = "riztile";
    rev = "babd5676a6c09808630e9be7675000ae845c46b5";
    hash = "sha256-Ip5Ladl8GeFSq5OYCvZO0wKkT/jao6YAQcbVoMGODJg=";
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
