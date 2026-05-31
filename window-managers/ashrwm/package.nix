{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
  libxkbcommon,
  wayland,
  wayland-protocols,
  callPackage,
  pkg-config,
  wayland-scanner,
  bison,
  libxml2,
  libffi,
  expat,
  libevdev,
  libinput,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ashrwm";
  version = "unstable-2026-05-25";

  src = fetchFromGitHub {
    owner = "shadowash8";
    repo = "ashrwm";
    rev = "29be6334b5395e1b063d5b0b145b4e9269c4b1ae";
    hash = "sha256-yy0/JekBmopr/fsl4N2O5nFB4q7NNcXKjvK4YDF84ag=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig
    wayland-scanner
    wayland-protocols
    pkg-config
    bison
  ];
  buildInputs = [
    libxkbcommon
    wayland
    libxml2
    libffi
    expat
    libevdev
    libinput
  ];

  postInstall = ''
    install -Dm755 $src/example/config.janet -t $out/example/
  '';

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ]
  ++ [ "-Doptimize=ReleaseSafe" ];

  meta = {
    homepage = "https://github.com/shadowash8/ashrwm";
    description = "Minimal dynamic tiling window manager with tiling, and grid layouts, hot reloading and more";
    longDescription = ''
      Ashrwm is a window manager for the river Wayland compositor, written in roughly 700 lines of Janet (https://janet-lang.org/).
      This WM features dynamic tiling, floating/sticky windows, hot reloading, and a REPL.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
