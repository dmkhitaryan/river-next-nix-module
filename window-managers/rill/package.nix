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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rill";
  version = "unstable-2026-09-06";

  src = fetchFromCodeberg {
    owner = "lzj15";
    repo = "rill";
    rev = "1aedbd48ab265a9976cfd9f43f5821bf33fa71d2";
    hash = "sha256-sf2NZ1/uKZ34Ak16EWz/tEhgQ1CA775Sh2uueuXnxTo=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig
    wayland-scanner
    pkg-config
  ];
  buildInputs = [
    libxkbcommon
    wayland
    wayland-protocols
  ]
  ++ lib.optional withManpages scdoc;

  postInstall = ''
    install -Dm755 $src/config.zon -t $out/example/
  '';

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ]
  ++ [ "-Doptimize=ReleaseSafe" ];

  meta = {
    homepage = "https://codeberg.org/lzj15/rill";
    description = "Minimalist scrolling window manager";
    longDescription = ''
      Rill is a minimalist scrolling window manager for river, implementing the river-window-management-v1 protocol, written in Zig.
      Rill supports animations and a live-reloadable configuration.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };

})
