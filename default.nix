{
  nixosModule = import ./river-module.nix;

  packages = {
    river-next = ./river-next.nix;
    ashrwm = ./window-managers/ashrwm/package.nix;
    beansprout = ./window-managers/beansprout/package.nix;
    bridge = ./window-managers/bridge/package.nix;
    canoe = ./window-managers/canoe/package.nix;
    kwm = ./window-managers/kwm/package.nix;
    machi = ./window-managers/machi/package.nix;
    notion-river = ./window-managers/notion-river/package.nix;
    orilla = ./window-managers/orilla/package.nix;
    rill = ./window-managers/rill/package.nix;
    rrwm = ./window-managers/rrwm/package.nix;
  };
}
