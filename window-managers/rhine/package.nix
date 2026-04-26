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
  libnotify,
}:
let
  river-next = callPackage ../../river-next.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rhine";
  version = "unstable-2026-04-27";

  src = fetchFromCodeberg {
    owner = "Sivecano";
    repo = "rhine";
    rev = "b2ade5357e812604ea818b14fcb478acd5cd1524";
    hash = "sha256-dnUgq2B1zwQiq8/HyABzm2GCuX6BHYkIRmPv+r28SB8=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  postPatch = ''
substituteInPlace build.zig \
  --replace-fail \
    '    const keysyms = b.addTranslateC(.{
        .optimize = optimize,
        .target = target,
        .root_source_file = b.path("src/xkb.h"),
    });

    const exe = b.addExecutable(.{' \
    '    const keysyms = b.addTranslateC(.{
        .optimize = optimize,
        .target = target,
        .root_source_file = b.path("src/xkb.h"),
    });
    keysyms.linkSystemLibrary("xkbcommon", .{ .use_pkg_config = .force });

    const exe = b.addExecutable(.{'
  '';

  nativeBuildInputs = [
    zig
    wayland-scanner
    wayland-protocols
    pkg-config
    river-next
  ];
  buildInputs = [
    libxkbcommon
    wayland
    libnotify
  ];

  postInstall = ''
    install -Dm755 $src/config.rh -t $out/examples/
  '';

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ]
  ++ [ "-Doptimize=ReleaseSafe" ];

  meta = {
    homepage = "https://codeberg.org/Sivecano/rhine";
    description = "Recursive and modular window management for river";
    longDescription = ''
      Rhine is a window manager for the river wayland compositor (using the river-window-manager-v1 protocol).
      The aim is to allow for a modular system of tiling algorithms. Rhine is meant to be both capable and hackable.
    '';
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
