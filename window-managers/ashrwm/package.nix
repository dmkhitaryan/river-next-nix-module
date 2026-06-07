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
  version = "unstable-2026-06-06";

  src = fetchFromGitHub {
    owner = "shadowash8";
    repo = "ashrwm";
    rev = "2b5b554a70759cbed7f2c99c66d28af28d218a9e";
    hash = "sha256-s5EHxh00MWKTFMkiIApW934VSMVC7OgsD/Tbp9joym0=";
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
