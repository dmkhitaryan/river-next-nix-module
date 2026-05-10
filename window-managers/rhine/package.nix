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
  libnotify,
}:
let
  river-next = callPackage ../../river-next.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rhine";
  version = "0.1.0";

  src = fetchFromCodeberg {
    owner = "Sivecano";
    repo = "rhine";
    tag = finalAttrs.version;
    hash = "sha256-4jhHUc9Up2DvGNmKhG10TX62NCnTUXtDSRPISJyOMgQ=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig_0_15
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
