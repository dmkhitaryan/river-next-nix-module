{
  lib,
  emacs-pgtk,
  fetchFromGitHub,
  writeText,
  writeShellScriptBin,
  # Optional: extra Elisp packages for the bundled Emacs,
  # e.g. extraPackages = epkgs: [ epkgs.magit ];
  extraPackages ? (_: [ ]),
}:
let
  rau-el = emacs-pgtk.pkgs.trivialBuild {
    pname = "rau";
    version = "unstable-2026-11-05";

    src = fetchFromGitHub {
      owner = "thkoch2001";
      repo = "rau";
      rev = "e732530267297ac65c2a9f8b36f7a1fbd4e95dfc";
      hash = "sha256-XJ2zPQo9FCNEFs9wHwIiWJ7D1rTrhbNXkgK7utDakh8=";
    };

    packageRequires = [ emacs-pgtk.pkgs.lgr ];

    preInstall = ''
      mkdir -p $out/share/emacs/site-lisp
      cp -r protocol $out/share/emacs/site-lisp/
    '';
  };

  emacs = emacs-pgtk.pkgs.withPackages (epkgs: [ rau-el ] ++ extraPackages epkgs);

  # Rau needs the `server` library and its socket directory to exist.
  init = writeText "rau-init.el" ''
    ;;; rau-init.el --- -*- lexical-binding: t -*-
    (require 'server)
    (make-directory server-socket-dir t)
    (set-file-modes server-socket-dir #o700)
    (require 'rau)
    (rau-enable)
  '';
in
(writeShellScriptBin "rau" ''
  exec ${emacs}/bin/emacs -l ${init} "$@"
'').overrideAttrs
  (old: {
    passthru = (old.passthru or { }) // {
      elisp = rau-el;
    };

    meta = (old.meta or { }) // {
      homepage = "https://github.com/thkoch2001/rau";
      description = "Emacs/Wayland based Window Manager in pure elisp with the help of River";
      license = lib.licenses.gpl3Only;
      mainProgram = "rau";
      maintainers = with lib.maintainers; [
        dmkhitaryan
      ];
      platforms = lib.platforms.linux;
    };
  })
