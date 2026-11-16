{
  lib,
  stdenv,
  fetchFromCodeberg,
  withManpages ? true,
  scdoc,
  zig_0_17,
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
  version = "unstable-2026-11-10";

  src = fetchFromCodeberg {
    owner = "pkap";
    repo = "argen";
    rev = "a272dbc0b246d29203b2ea38b017682a939599c6";
    hash = "sha256-46vkwDi99JQtloa5oZGe7yzhCOvXbTtDoENHDNBGGAA=";
  };

  deps = callPackage ./build.zig.zon.nix {};

  nativeBuildInputs = [
    zig_0_17
    wayland-scanner
    pkg-config
  ];
  buildInputs =
    [
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

  zigBuildFlags =
    [
      "--system"
      "${finalAttrs.deps}"
    ]
    ++ ["-Doptimize=ReleaseSafe"];

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
