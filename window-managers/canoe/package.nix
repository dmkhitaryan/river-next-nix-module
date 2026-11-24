{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wayland-scanner,
  wayland,
  libxkbcommon,
  freetype,
  fontconfig,
  udev,
  seatd,
  libgbm,
  pixman,
  libinput,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "canoe";
  version = "0.7.0-beta.3";

  src = fetchFromGitHub {
    owner = "roblillack";
    repo = "canoe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zUKTUbhbGgX1IJhXqHpUQhsFU8OVXqYfVA32n4GZhnA=";
  };

  cargoHash = "sha256-E9z0krSG/15ziMDd4v8PUYzkVMeFrGEFci2Hg8ldUqI=";

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    libxkbcommon
    freetype
    fontconfig
    udev
    seatd
    libinput
    pixman
    libgbm
  ];

  meta = {
    homepage = "https://github.com/roblillack/canoe";
    description = "Stacking window manager for the River Wayland compositor";
    longDescription = ''
      Canoe is a stacking window manager for the River Wayland compositor, written in Rust.
      Among its features are server-side decorations, multihead support, and window focus following clicks.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
