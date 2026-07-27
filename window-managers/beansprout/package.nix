{
  lib,
  stdenv,
  fetchFromCodeberg,
  withManpages ? true,
  scdoc,
  zig,
  libxkbcommon,
  wayland,
  wayland-protocols,
  callPackage,
  pkg-config,
  wayland-scanner,
  fcft,
  pixman,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "beansprout";
  version = "unstable-2026-07-27";

  src = fetchFromCodeberg {
    owner = "beansprout";
    repo = "beansprout";
    rev = "f3b174b5f0f0946df22c656cec1cef82bc35dbf5";
    hash = "sha256-u1IvPy76udjP4PEGRabo5dMcrQhP5sn3vfFnayTdJ2Q=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig
    wayland-scanner
    pkg-config
  ];
  buildInputs = [
    wayland-protocols
    libxkbcommon
    wayland
    pixman
    fcft
  ]
  ++ lib.optional withManpages scdoc;

  postInstall = ''
    install -Dm755 examples/config.kdl -t $out/example/
  '';

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ]
  ++ [ "-Doptimize=ReleaseSafe" ];

  meta = {
    homepage = "https://codeberg.org/beansprout/beansprout";
    description = "DWM-style tiling window manager with built-in wallpaper and a clock/bar";
    longDescription = ''
      A tiling window manager DWM-style tiling window manager with built-in wallpaper and a clock/bar written in Zig. The window manager communicates using the river-window-management-v1 protocol, as well as some of River's additional Wayland protocols.
      Beansprout uses a primary/stack tiling layout inspired by dwm with a customizable ratio and primary count.
      Similarly, beansprout has a 32-bit tag system, rather than workspaces. Each output has its own tags and own primary count/ratio.
    '';
    license = with lib.licenses; [
      bsd0
      cc-by-40
      cc0
      gpl3Only
      hpnd
      mit
    ];
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
