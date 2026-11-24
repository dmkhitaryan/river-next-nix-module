{
  lib,
  stdenv,
  fetchFromCodeberg,
  zig_0_17,
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
  version = "unstable-2026-11-24";

  src = fetchFromCodeberg {
    owner = "Sivecano";
    repo = "rhine";
    rev = "32860d4d9064c17b4f8e905a877bbe9cd031d6c1";
    hash = "sha256-4Q8Huf/hgs/1acLJNhV77uFspoDSwlLHihZnW2/frR0=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  #  postPatch = ''
  #    substituteInPlace build.zig \
  #      --replace-fail \
  #      '@xkbcommonInclude@' \
  #      '${lib.getDev libxkbcommon}/include'
  #  '';

  nativeBuildInputs = [
    zig_0_17
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
