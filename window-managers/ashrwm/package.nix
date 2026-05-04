{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_15,
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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ashrwm";
  version = "unstable-2026-05-04";

  src = fetchFromGitHub {
    owner = "shadowash8";
    repo = "ashrwm";
    rev = "305339adfafea008d6700a1262393c5b0a79bb24";
    hash = "sha256-3nNgoOgEZDu/Cr9ve83K9HX8sxG+xbGoIxoE9On5mSs=";
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
    libffi
    expat
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
