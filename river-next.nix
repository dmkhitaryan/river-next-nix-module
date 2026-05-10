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
  versionCheckHook,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots_0_20,
  xwayland,
  zig,
  withManpages ? true,
  xwaylandSupport ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "river-next";
  version = "0.5.0-dev";
  outputs = [ "out" ] ++ lib.optionals withManpages [ "man" ];

  src = fetchFromCodeberg {
    owner = "river";
    repo = "river";
    rev = "07f1c87ae0bc748b3c41d6f717081e18b3256b7e";
    hash = "sha256-+XODmT/TjVKiXZJgleLiM/tVev9KUysoeb70TGp2tpQ=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    xwayland
    zig
  ]
  ++ lib.optional withManpages scdoc;

  buildInputs = [
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

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ]
  ++ lib.optional withManpages "-Dman-pages"
  ++ lib.optional xwaylandSupport "-Dxwayland"
  ++ [ "-Doptimize=ReleaseSafe" ];

  postInstall = ''
    install contrib/river.desktop -Dt $out/share/wayland-sessions
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  passthru = {
    providedSessions = [ "river" ];
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
