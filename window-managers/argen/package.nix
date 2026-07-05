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
  version = "0.1.1";

  src = fetchFromCodeberg {
    owner = "pkap";
    repo = "argen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cVcMprYLX1DpP8coAzi6Oqgmio63249nbOHXd70+9wA=";
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
