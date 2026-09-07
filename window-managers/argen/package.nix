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
  libevdev,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "argen";
  version = "unstable-2026-09-05";

  src = fetchFromCodeberg {
    owner = "pkap";
    repo = "argen";
    rev = "4910a2e7d7e113e15321d027e4ea7abf5420ba3e";
    hash = "sha256-XppoYhV0ntXmTa68nIwa2XLq8Zsi5tzIVL9Z00DXlNU=";
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
    libevdev
  ]
  ++ lib.optional withManpages scdoc;

  postInstall = ''
    install -Dm755 example/init -t $out/example/
  '';

  doInstallCheck = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ]
  ++ [ "-Doptimize=ReleaseSafe" ];

  meta = {
    homepage = "https://codeberg.org/pkap/argen";
    description = "Task-oriented tiling window manager designed for keyboard + IPC workflows";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
