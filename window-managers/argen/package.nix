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
  version = "unstable-2026-10-18";

  src = fetchFromCodeberg {
    owner = "pkap";
    repo = "argen";
    rev = "66a960ff7c8f2c1daccc3c6cb3f1700ee7167fae";
    hash = "sha256-AQcBrA9s41zNXjKuayDzHep8lp5kMpe8iqTELZPICoo=";
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
