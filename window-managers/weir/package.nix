{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  wayland-scanner,
  wayland,
  libxkbcommon,
}:

buildGoModule (finalAttrs: {
  pname = "weir";
  version = "unstable-2026-06-01";
  subPackages = [
    "cmd/weir"
    "cmd/weirctl"
    "cmd/wmsim"
  ];

  src = fetchFromGitHub {
    owner = "psanford";
    repo = "weir";
    rev = "929d9a5925e4a7f2a16faa999419e729ad3698e3";
    hash = "sha256-9pCjyF3Le5CKfBPIU7Nv2Nd2HkEwv6+De/JxhESH85k=";
  };

  vendorHash = null;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    libxkbcommon
  ];

  postInstall = ''
    install -Dm755 example/init $out/example/init
    makeWrapper $out/example/init $out/bin/weir-init \
      --prefix PATH : $out/bin
  '';

  meta = {
    homepage = "https://github.com/psanford/weir";
    description = "Tiling window manager inspired by XMonad and Rivercarro, dynamic CLI configuration";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
})
