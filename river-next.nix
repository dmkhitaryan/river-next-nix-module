{
  lib,
  stdenv,
  callPackage,
  fetchFromCodeberg,
  libGL,
  libx11,
  libevdev,
  libinput,
  libxkbcommon,
  pixman,
  pkg-config,
  scdoc,
  udev,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots_0_20,
  xwayland,
  zig_0_17,
  withManpages ? true,
  xwaylandSupport ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "river-next";
  version = "unstable-2026-11-05";
  outputs = ["out"] ++ lib.optionals withManpages ["man"];

  src = fetchFromCodeberg {
    owner = "river";
    repo = "river";
    rev = "547b67a9f303b15733bf87f0fbebcbf7b4709f0b";
    hash = "sha256-BP7RCSn8z2x0Tvhd/sGiVF40zYXQyHM7dmfdso7kftc=";
  };

  deps = callPackage ./build.zig.zon.nix {};

  nativeBuildInputs =
    [
      pkg-config
      wayland-scanner
      zig_0_17
    ]
    ++ lib.optional withManpages scdoc
    ++ lib.optional xwaylandSupport xwayland;

  buildInputs =
    [
      libGL
      libevdev
      libinput
      libxkbcommon
      pixman
      udev
      wayland
      wayland-protocols
      wlroots_0_20
    ]
    ++ lib.optional xwaylandSupport libx11;

  zigBuildFlags =
    [
      "--system"
      "${finalAttrs.deps}"
    ]
    ++ lib.optional withManpages "-Dman-pages"
    ++ lib.optional xwaylandSupport "-Dxwayland"
    ++ ["-Doptimize=ReleaseSafe"];

  postInstall = ''
    install contrib/river.desktop -Dt $out/share/wayland-sessions
  '';

  passthru = {
    providedSessions = ["river"];
  };

  meta = {
    homepage = "https://codeberg.org/river/river-classic";
    description = "Dynamic tiling wayland compositor";
    longDescription = ''
      River is a non-monolithic Wayland compositor.
      Unlike other Wayland compositors, river does not combine the compositor and window manager into one program.
      Instead, users can choose any window manager implementing the river-window-management-v1 protocol.
    '';
    changelog = "https://codeberg.org/river/river/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # Includes original maintainers when the file was used to generate the new version. Note: the release has now dropped on Nixpkgs.
      adamcstephens
      moni
      rodrgz
      dmkhitaryan
    ];
    mainProgram = "river";
    platforms = lib.platforms.linux;
  };
})
