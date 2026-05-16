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
  version = "unstable-2026-05-16";

  src = fetchFromGitHub {
    owner = "shadowash8";
    repo = "ashrwm";
    rev = "485c22350cb7c061b1d46bbddc9577e57ccb01a6";
    hash = "sha256-QgztPhpkJMJ8hOgQlRylOq7GyAn4dxkk2SWZskR8ZF4=";
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
