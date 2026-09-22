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
  version = "unstable-2026-09-16";
  subPackages = [
    "cmd/weir"
    "cmd/weirctl"
    "cmd/wmsim"
  ];

  src = fetchFromGitHub {
    owner = "psanford";
    repo = "weir";
    rev = "0d112a8b8c41f02babc35a595ed476f15fc7ebf6";
    hash = "sha256-kox++N+plpZa9qJiAlebZ6KK8bCCwy0TdjXEU/8sE0g=";
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
