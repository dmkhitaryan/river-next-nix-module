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
    version = "unstable-2026-10-20";

    src = fetchFromGitHub {
      owner = "thkoch2001";
      repo = "rau";
      rev = "74f4326723d2c5b2723a178813366cb69a922de3";
      hash = "sha256-WfDn19X862rJt6EK3wOHOE0dOeh2CCDdZl/CnmaTAjA=";
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
