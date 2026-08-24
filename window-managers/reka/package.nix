{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  pkg-config,
  wayland-scanner,
  wayland,
  libxkbcommon,
  wayland-protocols,
  emacsPackages,
  fetchurl,
}: # Packaging approach adopted from https://codeberg.org/tazjin/reka/src/branch/canon/default.nix

let
  reka = rustPlatform.buildRustPackage {
    pname = "reka-lib";
    version = "unstable-2026-08-16";

    src = fetchFromCodeberg {
      owner = "tazjin";
      repo = "reka";
      rev = "07de418fedd226b3a807c9ed0fb06eda9f697e0c";
      hash = "sha256-jdggakCHHRNpRQUjpHHHWyBsU1SL61QIWZMV6A0IWfU=";
    };

    cargoHash = "sha256-h5FTiU6zR0+w0KVnrjjaeQkSXOuCrQOXbZinJMLrNiY=";

    nativeBuildInputs = [
      pkg-config
      wayland-scanner
    ];

    buildInputs = [
      wayland
      libxkbcommon
      wayland-protocols
    ];

    postInstall = ''
      mkdir -p $out/share/emacs/site-lisp
      ln -s $out/lib/libreka.so $out/share/emacs/site-lisp/libreka.so
    '';
  };
in
emacsPackages.trivialBuild {
  pname = "reka";
  version = "unstable-2026-08-16";
  src = fetchurl {
    url = "https://codeberg.org/tazjin/reka/raw/branch/canon/lisp/reka.el";
    hash = "sha256-cdjwUG7q1279BsZke1MGGC9Rz5qGuZZYWrKE6aRhcqA=";
  };
  packageRequires = [ reka ];

  passthru.reka-lib = reka;

  meta = {
    homepage = "https://code.tvl.fyi/about/tools/emacs-pkgs/reka";
    description = "Emacs-based window manager for river";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dmkhitaryan
    ];
    platforms = lib.platforms.linux;
  };
}
