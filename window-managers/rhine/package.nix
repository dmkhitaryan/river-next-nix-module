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
  dbus,
}:
let
  river-next = callPackage ../../river-next.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rhine";
  version = "unstable-2026-10-18";

  src = fetchFromCodeberg {
    owner = "Sivecano";
    repo = "rhine";
    rev = "ff499d004ed283ca784d2494e40cfc17ebc8f77a";
    hash = "sha256-HLGWjJOqbvVn9R35TimqaxcX0e2nWlDKersDmD3viUY=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  #  postPatch = ''
  #    substituteInPlace build.zig \
  #      --replace-fail \
  #      '@xkbcommonInclude@' \
  #      '${lib.getDev libxkbcommon}/include'
  #  '';

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
    dbus
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
