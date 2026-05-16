{
  lib,
  stdenv,
  fetchFromCodeberg,
  zig_0_15,
  libxkbcommon,
  wayland,
  wayland-protocols,
  callPackage,
  pkg-config,
  wayland-scanner,
  bison,
  libxml2,
  expat,
  libffi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rijan";
  version = "unstable-2026-04-26";

  src = fetchFromCodeberg {
    owner = "ifreund";
    repo = "rijan";
    rev = "e4d390e446d4da87de98a6c235ef59c7a0905058";
    hash = "sha256-8ETIIgr3Ze27hSc6FF/oXO5M0eVlbP9kxrjx0t5qHBw=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig_0_15
    wayland-scanner
    wayland-protocols
    pkg-config
    bison
  ];
  buildInputs = [
    libxkbcommon
    wayland
    libxml2
    expat
    libffi
  ];

  postInstall = ''
    install -Dm755 $src/example/init.janet -t $out/example/
  '';

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ]
  ++ [ "-Doptimize=ReleaseSafe" ];

  meta = {
    homepage = "https://codeberg.org/ifreund/rijan";
    description = "Recursive and modular window management for river";
    longDescription = ''
      Rijan is a window manager for the river Wayland compositor, written in less than 600 lines of Janet (https://janet-lang.org/).
      Note that it is not intended for a daily driver use, but can be forked off by others to build own window manager.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
